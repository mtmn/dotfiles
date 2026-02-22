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

(local diagnostic-keymaps {:<leader>gl :open_float
                           :<leader>gp :goto_prev
                           :<leader>gn :goto_next})

(each [key func (pairs diagnostic-keymaps)]
  (vim.keymap.set :n key (.. "<cmd>lua vim.diagnostic." func "()<CR>")))

(vim.keymap.set :v :<leader>gf
                "<cmd>lua vim.lsp.buf.format({async = true})<CR>")

(vim.keymap.set :i :<C-Space> "<cmd>lua vim.lsp.buf.completion()<CR>")

(vim.keymap.set :n :x "\"_x")
