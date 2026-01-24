(local home (os.getenv :HOME))
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

(vim.api.nvim_create_autocmd :BufWritePre
                             {:callback (fn [ev]
                                          (vim.lsp.buf.code_action {:apply true
                                                                    :context {:only [:source.fixAll]}}))
                              :pattern [:*.zig :*.zon]})
