(local {:nvim_command command :nvim_create_autocmd autocmd} vim.api)
(local {: keys} (require :std.table))

(local ts (require :nvim-treesitter))
(local all-parsers (keys (require :nvim-treesitter.parsers)))

(fn build []
  (: (ts.install all-parsers) :wait 300000)
  (: (ts.update all-parsers) :wait 300000))

; To force rebuild:
; rm -rf ~/.local/share/nvim/site
; (ts.install all-parsers {:force true})

;; Adapted from https://github.com/nvim-treesitter/nvim-treesitter/discussions/7894
(fn config []
  (local parsers (require :nvim-treesitter.parsers))
  (autocmd :FileType
           {:callback (fn []
                        (let [lang (vim.treesitter.language.get_lang vim.bo.filetype)]
                          (when (and lang (parsers.has_parser lang))
                            (vim.treesitter.start)
                            (set vim.wo.foldexpr
                                 "v:lua.vim.treesitter.foldexpr()")
                            (set vim.bo.indentexpr
                                 "v:lua.require'nvim-treesitter'.indentexpr()"))))}))

{: build : config}
