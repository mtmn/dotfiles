(vim.api.nvim_create_autocmd [:BufRead :BufNewFile]
                             {:pattern [:*.m3u :*.m3u8]
                              :callback (fn []
                                          (set vim.bo.filetype :text)
                                          (set vim.bo.syntax :text))})

(let [group (vim.api.nvim_create_augroup :MagdalenaLogFile {:clear true})]
  (vim.api.nvim_create_autocmd [:BufReadPost :BufNewFile]
                               {: group
                                :callback (fn [ev]
                                            (let [filename (vim.api.nvim_buf_get_name ev.buf)]
                                              (when (and filename
                                                         (not= filename "")
                                                         (not (filename:match "^oil://")))
                                                (let [_job (vim.fn.jobstart [:magdalena
                                                                             :log-file
                                                                             filename]
                                                                            {:detach true
                                                                             :on_stderr (fn [_
                                                                                             _])
                                                                             :on_exit (fn [_
                                                                                           _])})]
                                                  nil))))}))

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
