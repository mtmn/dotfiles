(local home (os.getenv :HOME))
(local secrets (require :secrets))

(fn navigate-to-dir []
  (let [current-line (vim.api.nvim_get_current_line)
        clean-line (if (= (current-line:sub -1) "/")
                       (current-line:sub 1 -2)
                       current-line)
        full-path (.. home secrets.magnolia clean-line)]
    (vim.fn.chdir full-path)
    (vim.cmd :ToggleTerm)
    (vim.cmd "cd ~")))

(fn play-dir-in-fooyin []
  (let [current-line (vim.api.nvim_get_current_line)
        clean-line (if (= (current-line:sub -1) "/")
                       (current-line:sub 1 -2)
                       current-line)
        full-path (.. home secrets.magnolia clean-line)]
    (vim.fn.chdir full-path)
    (vim.system [:fooyin full-path] {:detach true})
    (vim.cmd "cd ~")))

(fn log-file-event [action]
  (let [file-path (vim.fn.expand "%:p")]
    (when (and (not= file-path "") (not= file-path nil))
      (let [db-path (.. (vim.fn.expand :$HOME) :/.magnolia.db)
            escaped-path (file-path:gsub "'" "''")
            sql-query (string.format "INSERT INTO file_history (path, file_type, action) VALUES ('%s', '%s', '%s');"
                                     escaped-path file-type action)
            command (string.format "sqlite3 '%s' \"%s\"" db-path sql-query)]
        (vim.fn.system command)))))

(let [augroup (vim.api.nvim_create_augroup :FzfFileHistory {:clear true})]
  (vim.api.nvim_create_autocmd [:BufReadPost]
                               {:group augroup
                                :pattern "*"
                                :callback (fn [] (log-file-event :open))})
  (vim.api.nvim_create_autocmd [:BufWritePost]
                               {:group augroup
                                :pattern "*"
                                :callback (fn [] (log-file-event :open))}))

(vim.api.nvim_create_user_command :Mnav navigate-to-dir {})
(vim.api.nvim_create_user_command :Mfoo play-dir-in-fooyin {})

(vim.api.nvim_create_autocmd [:BufRead :BufNewFile]
                             {:pattern [:*.m3u :*.m3u8]
                              :callback (fn []
                                          (set vim.bo.filetype :m3u)
                                          (set vim.bo.syntax :m3u))})

; this helps with performance as render-markdown.nvim is slow on big files
(vim.api.nvim_create_autocmd [:BufRead :BufNewFile]
                             {:pattern (.. (vim.fn.expand :$HOME)
                                           :/misc/notes/releases/*)
                              :callback (fn []
                                          (set vim.bo.filetype :m3u)
                                          (set vim.bo.syntax :m3u))})
