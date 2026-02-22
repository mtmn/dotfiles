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
    (use "neogitorg/neogit"
         {:dependencies [:nvim-lua/plenary.nvim :sindrets/diffview.nvim]
          :config true})
    (use "saghen/blink.cmp"
	{:version :^1
	:lazy false
	:dependencies [:L3MON4D3/LuaSnip]
	:config #(: (require :config.blink) :config)})
    (use "mrcjkb/rustaceanvim" {:version :^7 :lazy false})
    (use "neovim/nvim-lspconfig"
         {:event :VeryLazy
          :branch :master
          :config (fn []
                    (: (require :config.lsp) :config))})
    (use "nvim-treesitter/nvim-treesitter"
         {:branch :main
          :build #(: (require :config.treesitter) :build)
          :config #(: (require :config.treesitter) :config)})
    (use "tpope/vim-commentary")
    (use "tpope/vim-repeat")
    (use "tpope/vim-surround")
    (use "troydm/zoomwintab.vim")
(use "danobi/prr"
     {:init (fn []
              (vim.opt.rtp:prepend (.. (vim.fn.stdpath :data) "/lazy/prr/vim"))
              (vim.filetype.add {:extension {:prr :prr}}))})
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

(init)
