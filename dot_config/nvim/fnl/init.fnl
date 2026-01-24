(vim.loader.enable)

(local {: g : env : fs} vim)
(local {:nvim_command command} vim.api)
(local {: stdpath : empty : glob} vim.fn)
(local {: format} string)

(fn bootstrap-lazy []
  (local lazypath (.. (vim.fn.stdpath :data) :/lazy/lazy.nvim))
  (when (not (vim.uv.fs_stat lazypath))
    (local lazyrepo "https://github.com/folke/lazy.nvim.git")
    (local out (vim.fn.system [:git
                               :clone
                               "--filter=blob:none"
                               :--branch=stable
                               lazyrepo
                               lazypath]))
    (when (not= vim.v.shell_error 0)
      (vim.fn.getchar)
      (os.exit 1)))
  (vim.opt.rtp:prepend lazypath)
  (require :lazy))

;; fnlfmt: skip
(fn plugin_specs []
  (fn use [name opts]
    (let [opts (or opts {})]
      (tset opts 1 name)
      opts))

  [
    (use "oonamo/ef-themes.nvim"
         {:version false
          :lazy false
          :priority 1000
          :config (fn []
                    (set vim.opt.background :dark)
                    (vim.cmd.colorscheme :ef-tritanopia-dark))})

    (use "windwp/nvim-autopairs" {:event :VeryLazy :config true})
    (use "ibhagwan/fzf-lua" {:config true})
    (use "smoka7/hop.nvim" {:version "*" :opts {:keys :etovxqpdygfblzhckisuran}})
    (use "Olical/nfnl" {:ft :fennel})

    (use "nullchilly/fsread.nvim"
         {:version "*"
          :opts {}
          :config (fn []
                    (set vim.g.flow_strength 0.7)
                    (vim.api.nvim_set_hl 0 :FSPrefix {:fg "#cdd6f4"})
                    (vim.api.nvim_set_hl 0 :FSSuffix {:fg "#6C7086"}))})

    (use "MeanderingProgrammer/render-markdown.nvim" {:version "*" :opts {}})

    (use "stevearc/oil.nvim"
         {:config (fn []
                    ((. (require :oil) :setup) {:view_options {:show_hidden false}})
                    (let [oil-cd-on-enter (fn []
                                            (let [oil (require :oil)
                                                  current-dir (oil.get_current_dir)]
                                              (when current-dir
                                                (vim.cmd (.. "cd " current-dir)))))]
                      (vim.api.nvim_create_autocmd :BufEnter
                                                   {:pattern "oil://*"
                                                    :callback oil-cd-on-enter})))})

    (use "NeogitOrg/neogit"
         {:dependencies [:nvim-lua/plenary.nvim :sindrets/diffview.nvim]
          :config true})


    (use "ray-x/go.nvim"
         {:config (fn [] ((. (require :go) :setup)))
          :event [:CmdlineEnter]
          :ft [:go :gomod]})

    (use "mrcjkb/rustaceanvim" {:version :^6 :lazy false})

    (use "hrsh7th/nvim-cmp"
         {:dependencies [:hrsh7th/cmp-nvim-lsp
                        :hrsh7th/cmp-buffer
                        :hrsh7th/cmp-path
                        :hrsh7th/cmp-vsnip]
          :config (fn []
                    (let [cmp (require :cmp)]
                      (cmp.setup {:snippet {:expand (fn [args]
                                                      ((. (require :luasnip)
                                                          :lsp_expand) args.body))}
                                  :window {:completion {:winhighlight "Normal:CmpNormal"}
                                           :documentation {:winhighlight "Normal:CmpNormal"}}
                                  :mapping (cmp.mapping.preset.insert {:ctrl-b (cmp.mapping.scroll_docs -4)
                                                                       :ctrl-f (cmp.mapping.scroll_docs 4)
                                                                       :ctrl-space (cmp.mapping.complete)
                                                                       :ctrl-e (cmp.mapping.abort)
                                                                       :enter (cmp.mapping.confirm {:select true})})
                                  :sources (cmp.config.sources [{:name :nvim_lsp}
                                                                {:name :luasnip}
                                                                {:name :path}]
                                                               [{:name :buffer}])})))})

    (use "neovim/nvim-lspconfig"
         {:event :VeryLazy
          :branch :master
          :dependencies [:williamboman/mason.nvim
                         :williamboman/mason-lspconfig.nvim
                         :WhoIsSethDaniel/mason-tool-installer.nvim]
          :config (fn []
                    ((. (require :mason) :setup))
		    ((. (require :mason-tool-installer) :setup) {:ensure_installed [:basedpyright
                                                                 :bash-debug-adapter
                                                                 :bash-language-server
                                                                 :bashls
                                                                 :black
                                                                 :buildifier
                                                                 :codelldb
                                                                 :dockerls
                                                                 :fennel_ls
                                                                 :gofumpt
                                                                 :golines
                                                                 :gomodifytags
                                                                 :gopls
                                                                 :gotests
                                                                 :hadolint
                                                                 :html
                                                                 :impl
                                                                 :intelephense
                                                                 :json-to-struct
                                                                 :lua-language-server
                                                                 :luacheck
                                                                 :php-cs-fixer
                                                                 :php-debug
                                                                 :phpactor
                                                                 :pint
                                                                 :revive
                                                                 :rust_analyzer
                                                                 :shellcheck
                                                                 :shfmt
                                                                 :starpls
                                                                 :staticcheck
                                                                 :stylua
                                                                 :vint
                                                                 :yamlls
                                                                 :zls]})
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
               :phpactor {}
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
                                  (open-floating-preview contents syntax opts ...)))))))})

    (use "google/vim-bazel")
    (use "adalessa/laravel.nvim"
         {:dependencies [:nvim-telescope/telescope.nvim
                        :tpope/vim-dotenv
                        :MunifTanjim/nui.nvim
                        :nvim-lua/plenary.nvim]
          :config true})

    (use "nvim-treesitter/nvim-treesitter"
         {:branch :main
          :build #(: (require :treesitter) :build)
          :config #(: (require :treesitter) :config)})

    (use "L3MON4D3/LuaSnip" {:dependencies [:saadparwaiz1/cmp_luasnip]})
    
    (use "tpope/vim-commentary")
    (use "tpope/vim-repeat")
    (use "tpope/vim-surround")
    (use "troydm/zoomwintab.vim")

    (use "noahfrederick/vim-composer" {:ft :php})
    (use "rest-nvim/rest.nvim" {:ft :http :config true})

    (use "mfussenegger/nvim-dap"
         {:dependencies [:rcarriga/nvim-dap-ui :nvim-neotest/nvim-nio]
          :config (fn []
                    (let [dap (require :dap)
                          dapui (require :dapui)]
                      (dapui.setup)
                      (set dap.listeners.after.event_initialized.dapui_config #(: dapui :open))
                      (set dap.listeners.before.event_terminated.dapui_config #(: dapui :close))
                      (set dap.listeners.before.event_exited.dapui_config #(: dapui :close))
                      (set dap.adapters.php
                           {:type :executable
                            :command :node
                            :args [(.. (vim.fn.stdpath :data) "/mason/packages/php-debug/extension/out/phpDebug.js")]})
                      (set dap.configurations.php
                           [{:type :php
                             :request :launch
                             :name "Listen for Xdebug"
                             :port 9003}])))})

    (use "nvim-neotest/neotest"
         {:dependencies [:nvim-neotest/nvim-nio
                        :nvim-lua/plenary.nvim
                        :antoinemadec/FixCursorHold.nvim
                        :nvim-treesitter/nvim-treesitter
                        :olimorris/neotest-phpunit
                        :rouge8/neotest-rust]
          :config (fn []
                    ((. (require :neotest) :setup)
                     {:adapters [(require :neotest-phpunit)
                                 (require :neotest-rust)]}))})

    (use "Civitasv/bazel.nvim" {:dependencies [:nvim-lua/plenary.nvim]})
  ])

(fn init []
  (let [vimrc (.. (vim.fn.stdpath :config) :/init_.vim)]
    (vim.cmd.source vimrc))
  (set vim.opt.clipboard :unnamedplus)
  (set package.path (.. (fs.normalize "~") "/.config/nvim/lua/?.lua,"
                        package.path))
  (local lazy (bootstrap-lazy))
  (lazy.setup {:spec (plugin_specs) :checker {:enabled false}})
  (each [_ module (ipairs [:aliases :keymaps :functions])]
    (require module)))

(if (not g.vscode) (init))
