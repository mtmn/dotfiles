(local opts {:noremap true :silent false})

(local fzf-keymaps {:<leader><leader> :files
                    :<leader>ff :git_status
                    :<leader>fh :oldfiles
                    :<leader>fg :grep_project
                    :<leader>b :buffers})

(each [key func (pairs fzf-keymaps)]
  (vim.keymap.set :n key (.. "<cmd>lua require('fzf-lua')." func "()<CR>")))

(local single-keymaps {:<leader>g :<cmd>Neogit<CR>
                       :- :<cmd>Oil<CR>
                       :f :<cmd>HopWord<CR>
                       :mn :<cmd>Mnav<CR>})

(each [key cmd (pairs single-keymaps)]
  (vim.keymap.set :n key cmd))

(local lsp-keymaps {:<leader>gg :hover
                    :<leader>gd :definition
                    :<leader>gD :declaration
                    :<leader>gi :implementation
                    :<leader>gt :type_definition
                    :<leader>gr :references
                    :<leader>gs :signature_help
                    :<leader>rr :rename
                    :<leader>ga :code_action
                    :<leader>tr :document_symbol})

(each [key func (pairs lsp-keymaps)]
  (vim.keymap.set :n key (.. "<cmd>lua vim.lsp.buf." func "()<CR>")))

(vim.keymap.set :n :<leader>ta
                (fn []
                  (let [row (. (vim.api.nvim_win_get_cursor 0) 1)]
                    (vim.api.nvim_buf_set_lines 0 row row false ["- [ ] "])
                    (vim.api.nvim_win_set_cursor 0 [(+ row 1) 5]))))

(vim.keymap.set :n :<leader>tt
                (fn []
                  (let [line (vim.api.nvim_get_current_line)]
                    (var new-line nil)
                    (if (line:match "%[ %]")
                        (set new-line (line:gsub "%[ %]" "[-]" 1))
                        (line:match "%[%-%]")
                        (set new-line (line:gsub "%[%-%]" "[x]" 1))
                        (line:match "%[x%]")
                        (set new-line (line:gsub "%[x%]" "[ ]" 1)))
                    (when new-line (vim.api.nvim_set_current_line new-line)))))

(local diagnostic-keymaps {:<leader>gl :open_float
                           :<leader>gp :goto_prev
                           :<leader>gn :goto_next})

(each [key func (pairs diagnostic-keymaps)]
  (vim.keymap.set :n key (.. "<cmd>lua vim.diagnostic." func "()<CR>")))

(vim.keymap.set :v :<leader>gf
                "<cmd>lua vim.lsp.buf.format({async = true})<CR>")

(vim.keymap.set :i :<C-Space> "<cmd>lua vim.lsp.buf.completion()<CR>")

(vim.keymap.set :n :x "\"_x")
