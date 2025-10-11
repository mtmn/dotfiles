[{1 :miikanissi/modus-themes.nvim
  :version false
  :lazy false
  :priority 1000
  :config (fn []
            (set vim.opt.background :dark)
            (vim.cmd.colorscheme :modus_vivendi)
            (vim.api.nvim_set_hl 0 :Normal {:bg :none})
            (vim.api.nvim_set_hl 0 :NormalFloat {:bg :none})
            (vim.api.nvim_set_hl 0 :LineNrAbove {:bg :none})
            (vim.api.nvim_set_hl 0 :LineNrBelow {:bg :none})
            (vim.api.nvim_set_hl 0 :CursorLineNr {:bg :none})
            (vim.api.nvim_set_hl 0 :NormalNC {:bg :none}))}
 {1 :Olical/nfnl :ft :fennel}
 {1 :windwp/nvim-autopairs :event :VeryLazy :config true}
 {1 :ibhagwan/fzf-lua :config true}
 {1 :smoka7/hop.nvim :version "*" :opts {:keys :etovxqpdygfblzhckisuran}}
 {1 :nullchilly/fsread.nvim
  :version "*"
  :opts {}
  :config (fn []
            (set vim.g.flow_strength 0.7)
            (vim.api.nvim_set_hl 0 :FSPrefix {:fg "#cdd6f4"})
            (vim.api.nvim_set_hl 0 :FSSuffix {:fg "#6C7086"}))}
 {1 :andrewferrier/wrapping.nvim
  :version "*"
  :opts {}
  :config (fn []
            ((. (require :wrapping) :setup)))}
 {1 :folke/zen-mode.nvim :version "*" :opts {}}
 {1 :MeanderingProgrammer/render-markdown.nvim :version "*" :opts {}}
 {1 :stevearc/oil.nvim
  :config (fn []
            ((. (require :oil) :setup) {:view_options {:show_hidden false}})
            (local oil-cd-on-enter
                   (fn []
                     (local oil (require :oil))
                     (local dir (oil.get_current_dir))
                     (when dir
                       (vim.cmd (.. "cd " dir)))))
            (vim.api.nvim_create_autocmd :BufEnter
                                         {:pattern "oil://*"
                                          :callback oil-cd-on-enter}))}
 {1 :NeogitOrg/neogit
  :dependencies [:nvim-lua/plenary.nvim :sindrets/diffview.nvim]
  :config true}
 {1 :akinsho/toggleterm.nvim
  :version "*"
  :lazy false
  :config true
  :opts {:direction :horizontal
         :start_in_insert true
         :shade_terminals false
         :float_opts {:border :single :width 200 :height 40}}}
 {1 :tidalcycles/vim-tidal :config (fn [])}
 {1 :ray-x/go.nvim
  :config (fn []
            ((. (require :go) :setup)))
  :event [:CmdlineEnter]
  :ft [:go :gomod]}
 {1 :mrcjkb/rustaceanvim :version :^6 :lazy false}
 {1 :hrsh7th/nvim-cmp
  :dependencies [:hrsh7th/cmp-nvim-lsp :hrsh7th/cmp-buffer :hrsh7th/cmp-vsnip]
  :config (fn []
            (local cmp (require :cmp))
            (cmp.setup {:snippet {:expand (fn [args]
                                            ((. (require :luasnip) :lsp_expand) args.body))}
                        :window {:completion {:winhighlight "Normal:CmpNormal"}
                                 :documentation {:winhighlight "Normal:CmpNormal"}}
                        :mapping (cmp.mapping.preset.insert {:<C-b> (cmp.mapping.scroll_docs -4)
                                                             :<C-f> (cmp.mapping.scroll_docs 4)
                                                             :<C-Space> (cmp.mapping.complete)
                                                             :<C-e> (cmp.mapping.abort)
                                                             :<CR> (cmp.mapping.confirm {:select true})})
                        :sources (cmp.config.sources [{:name :nvim_lsp}
                                                      {:name :luasnip}]
                                                     [{:name :buffer}])}))}
 {1 :neovim/nvim-lspconfig
  :event :VeryLazy
  :dependencies [:williamboman/mason.nvim
                 :williamboman/mason-lspconfig.nvim
                 :WhoIsSethDaniel/mason-tool-installer.nvim]
  :config (fn []
            ((. (require :mason) :setup))
            ((. (require :mason-lspconfig) :setup) {:ensure_installed [:elp
                                                                       :marksman
                                                                       :yamlls
                                                                       :dockerls
                                                                       :bashls
                                                                       :gopls
                                                                       :ltex]})
            ((. (require :mason-tool-installer) :setup) {:ensure_installed [:lua-language-server
                                                                            :vim-language-server
                                                                            :stylua
                                                                            :shellcheck
                                                                            :gofumpt
                                                                            :golines
                                                                            :gomodifytags
                                                                            :gotests
                                                                            :impl
                                                                            :json-to-struct
                                                                            :luacheck
                                                                            :revive
                                                                            :shellcheck
                                                                            :shfmt
                                                                            :staticcheck
                                                                            :vint
                                                                            :ruby-lsp
                                                                            :fennel_ls]})
            (local servers
                   {:marksman {}
                    :yamlls {}
                    :clangd {}
                    :fennel_ls {}
                    :dockerls {}
                    :expert {}
                    :bashls {}
                    :rust_analyzer {}
                    :ruby-lsp {}
                    :gopls {:settings {:gopls {:analyses {:unusedparams true}
                                               :staticcheck true
                                               :gofumpt true}}}
                    :harper-ls {:settings {:harper-ls {:SentenceCapitalization false
                                                       :SpellCheck true}}}
                    :ltex {:filetypes [:latex
                                       :typst
                                       :typ
                                       :bib
                                       :markdown
                                       :plaintex
                                       :tex]
                           :settings {:ltex {:enabled [:latex
                                                       :typst
                                                       :typ
                                                       :bib
                                                       :markdown
                                                       :plaintex
                                                       :tex]}}}})
            (each [server config (pairs servers)]
              (vim.lsp.config server config))
            (local open-floating-preview vim.lsp.util.open_floating_preview)
            (vim.lsp.config :expert
                            {:cmd [:expert]
                             :root_markers [:mix.exs :.git]
                             :filetypes [:elixir :eelixir :heex]})
            (vim.lsp.enable :expert)
            (set vim.lsp.util.open_floating_preview
                 (fn [contents syntax opts ...]
                   (local opts (or opts {}))
                   (set opts.border (or opts.border :rounded))
                   (open-floating-preview contents syntax opts ...))))}
 {1 :nvim-treesitter/nvim-treesitter
  :build ":TSUpdate"
  :config (fn []
            (local configs (require :nvim-treesitter.configs))
            (configs.setup {:ensure_installed [:bash
                                               :erlang
                                               :elixir
                                               :fennel
                                               :go
                                               :java
                                               :json
                                               :lua
                                               :markdown
                                               :python
                                               :toml
                                               :xml
                                               :yaml]
                            :sync_install false
                            :highlight {:enable true}
                            :indent {:enable true}}))}
 {1 :L3MON4D3/LuaSnip :dependencies [:saadparwaiz1/cmp_luasnip]}
 [:tpope/vim-commentary :tpope/vim-repeat :tpope/vim-surround]
 :troydm/zoomwintab.vim
 :vim-erlang/vim-erlang-runtime]
