(local home (os.getenv :HOME))

(fn log-file-event [action]
  (let [file-path (vim.fn.expand "%:p")]
    (when (and (not= file-path "") (not= file-path nil))
      (let [db-path (.. (vim.fn.expand :$HOME) :/.magnolia.db)
            escaped-path (file-path:gsub "'" "''")
            sql-query (string.format "DELETE FROM file_history WHERE path LIKE 'oil://%%'; INSERT INTO file_history (path, file_type, action) VALUES ('%s', '%s', '%s');"
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
                                          (set vim.bo.filetype :text)
                                          (set vim.bo.syntax :text))})

(vim.api.nvim_create_autocmd :BufWritePre
                             {:callback (fn [ev]
                                          (vim.lsp.buf.code_action {:apply true
                                                                    :context {:only [:source.fixAll]}}))
                              :pattern [:*.zig :*.zon]})

(vim.api.nvim_create_autocmd :FileType
                             {:pattern :markdown
                              :callback (fn []
                                          (set vim.opt_local.suffixesadd :.md)
                                          (set vim.opt_local.includeexpr
                                               "v:lua.follow_md_link()")
                                          (global follow_md_link
                                                  #(: vim.v.fname :gsub
                                                      "%[%[(.-)%]%]" "%1"))
                                          (vim.keymap.set :n :gf
                                                          (fn []
                                                            (let [line (vim.api.nvim_get_current_line)
                                                                  col (. (vim.api.nvim_win_get_cursor 0)
                                                                         2)
                                                                  link (line:match "%[([%w_%-][%w_%-]+)%]"
                                                                                   col)]
                                                              (if link
                                                                  (vim.cmd (.. "edit "
                                                                               link
                                                                               :.md))
                                                                  (vim.cmd "normal! gf"))))
                                                          {:buffer true}))})
