#!/usr/bin/env bb

(ns habitual
  (:require [clojure.string :as str]
            [clojure.tools.cli :refer [parse-opts]]
            [babashka.process :refer [shell]]))

(defn parse-cron-field [field lo hi]
  (let [all (set (range lo (inc hi)))]
    (reduce
     (fn [acc part]
       (cond
         (= part "*")
         (into acc all)

         (re-matches #"\*/\d+" part)
         (let [step (parse-long (subs part 2))]
           (into acc (range lo (inc hi) step)))

         (re-matches #"\d+-\d+/\d+" part)
         (let [[range-part step-part] (str/split part #"/")
               [a b] (map parse-long (str/split range-part #"-"))
               step (parse-long step-part)]
           (into acc (range a (inc b) step)))

         (re-matches #"\d+-\d+" part)
         (let [[a b] (map parse-long (str/split part #"-"))]
           (into acc (range a (inc b))))

         :else
         (conj acc (parse-long part))))
     #{}
     (str/split field #","))))

(defn parse-cron [expr]
  (let [[minutes hours days months weekdays] (str/split expr #"\s+")]
    {:minutes  (parse-cron-field minutes  0 59)
     :hours    (parse-cron-field hours    0 23)
     :days     (parse-cron-field days     1 31)
     :months   (parse-cron-field months   1 12)
     :weekdays (parse-cron-field weekdays 0 6)}))

(defn next-cron-ms
  "Returns milliseconds until the next matching cron instant."
  [cron]
  (let [now (System/currentTimeMillis)
        start (-> now (quot 60000) inc (* 60000))]
    (loop [t start]
      (if (> t (+ start (* 4 366 24 60 60 1000)))
        (throw (ex-info "No cron match found within 4 years" {:cron cron}))
        (let [ldt     (java.time.LocalDateTime/ofInstant
                        (java.time.Instant/ofEpochMilli t)
                        (java.time.ZoneId/systemDefault))
              month   (.getMonthValue ldt)          ; 1-12
              mday    (.getDayOfMonth ldt)           ; 1-31
              hour    (.getHour ldt)                 ; 0-23
              minute  (.getMinute ldt)               ; 0-59
              weekday (-> ldt .getDayOfWeek .getValue (mod 7))] ; 0=Sun (ISO Mon=1, so Sun=7 mod 7=0)
          (if (and ((:months cron)   month)
                   ((:days cron)     mday)
                   ((:weekdays cron) weekday)
                   ((:hours cron)    hour)
                   ((:minutes cron)  minute))
            (- t now)
            (recur (+ t 60000))))))))

(defn run-job! [name cron prog]
  (future
    (loop []
      (let [delay-ms (next-cron-ms cron)]
        (println (format "[INFO] Scheduling next run for '%s' in %d seconds"
                         name (quot delay-ms 1000)))
        (Thread/sleep delay-ms)
        (println (format "[INFO] Running notifier for '%s'" name))
        (let [result (shell {:continue true} prog name)]
          (when (not= 0 (:exit result))
            (println (format "[WARN] Command returned %d: %s %s"
                             (:exit result) prog name))))
        (recur)))))

(def cli-options
  [["-p" "--prog PROG" "Program to send notifications to"
    :default "notify-send -u critical"]
   ["-h" "--help"]])

(defn -main [& args]
  (let [{:keys [options summary errors]} (parse-opts args cli-options)]
    (when errors
      (println (str/join "\n" errors))
      (System/exit 1))
    (when (:help options)
      (println "Usage: habitual [options]")
      (println summary)
      (System/exit 0))

    (let [config-file (str (System/getProperty "user.home")
                           "/.config/habitual/habitual")
          lines       (-> config-file slurp str/split-lines)
          prog        (:prog options)
          jobs        (for [line lines
                            :let [line (str/trim line)]
                            :when (and (seq line) (not (str/starts-with? line "#")))
                            :let [[schedule name] (str/split line #"\|" 2)
                                  cron (parse-cron (str/trim schedule))]]
                        (run-job! (str/trim name) cron prog))]
      (println (format "[INFO] Loaded %d job(s), running..." (count (doall jobs))))
      ;; Block forever — futures run the jobs
      @(promise))))

(apply -main *command-line-args*)
