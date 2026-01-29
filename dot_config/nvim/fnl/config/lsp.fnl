(local {: map} (require :std.functional))
(local tbl (require :std.table))
;; (local local-plugins-lspconfig (require :local.plugins.lspconfig)) ; check if we need this

(local {:nvim_create_augroup create-augroup
        :nvim_create_autocmd create-autocmd
        :nvim_clear_autocmds clear-autocmds
        :nvim_get_current_buf get-current-buf} vim.api)

(create-augroup :local-lsp-auto-format {:clear true})

(fn is-array [tbl]
  (not (not (. tbl 1))))

(fn map-vals [func tbl]
  (map #(func $2) tbl))

(fn create-auto-format-autocmd [extra-opts]
  (let [extra-opts (or extra-opts {})
        all-extra-opts (if (is-array extra-opts)
                           extra-opts
                           [extra-opts])
        all-opts (map-vals #(tbl.merge {:formatting_options {:timeout_ms 5000}}
                                       $1)
                           all-extra-opts)
        auto-format-callback #(each [_ opts (ipairs all-opts)]
                                (vim.lsp.buf.format opts))]
    (clear-autocmds {:event :BufWritePre
                     :buffer (get-current-buf)
                     :group :local-lsp-auto-format})
    (create-autocmd :BufWritePre
                    {:buffer (get-current-buf)
                     :callback auto-format-callback
                     :group :local-lsp-auto-format})
    nil))

(fn auto-format-on-save [filetypes extra-opts]
  (let [callback #(create-auto-format-autocmd extra-opts)]
    (each [_ filetype (ipairs filetypes)]
      (create-autocmd :FileType {:pattern filetype : callback}))))

(fn config []

  (let [servers {:basedpyright {}
                 :bash-language-server {}
                 :bashls {}
                 :clangd {}
                 :dockerls {}
                 :fennel_ls {}
                 :gopls {:settings {:gopls {:analyses {:unusedparams true}
                                            :staticcheck true
                                            :gofumpt true}}}
                 :html {}
                 :intelephense {}
                 :lua-language-server {}
                 :rust_analyzer {}
                 :starpls {}
                 :yamlls {}
                 :zls {}}]
    (each [server config (pairs servers)]
      (vim.lsp.enable server config))
    (let [open-floating-preview vim.lsp.util.open_floating_preview]
      (set vim.lsp.util.open_floating_preview
           (fn [contents syntax opts ...]
             (let [opts (or opts {})]
               (set opts.border (or opts.border :rounded))
               (open-floating-preview contents syntax opts ...))))))
  ;; Enable inline diagnostics
  (vim.diagnostic.config {:virtual_text true}))

{: auto-format-on-save : config}
