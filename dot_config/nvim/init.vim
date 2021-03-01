" phaazon’s neovim configuration

source ~/.config/nvim/common.vim
source ~/.config/nvim/lang.vim
source ~/.config/nvim/plug.vim
source ~/.config/nvim/key_bindings.vim
source ~/.config/nvim/colorscheme.vim

lua require('treesitter-config')
lua require('devicons-config')


" lua require'lspconfig'.terraformls.setup{cmd = {'terraform-ls', 'serve'}}

autocmd BufReadPost *.kt setlocal filetype=kotlin

let g:LanguageClient_serverCommands = {
    \ 'kotlin': ["kotlin-language-server"],
    \ }
