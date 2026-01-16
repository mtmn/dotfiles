-- [nfnl] plugins.fnl
local function _1_()
  vim.opt.background = "dark"
  return vim.cmd.colorscheme("ef-tritanopia-dark")
end
local function _2_()
  vim.g.flow_strength = 0.7
  vim.api.nvim_set_hl(0, "FSPrefix", {fg = "#cdd6f4"})
  return vim.api.nvim_set_hl(0, "FSSuffix", {fg = "#6C7086"})
end
local function _3_()
  return require("wrapping").setup()
end
local function _4_()
  require("oil").setup({view_options = {show_hidden = false}})
  local oil_cd_on_enter
  local function _5_()
    local oil = require("oil")
    local dir = oil.get_current_dir()
    if dir then
      return vim.cmd(("cd " .. dir))
    else
      return nil
    end
  end
  oil_cd_on_enter = _5_
  return vim.api.nvim_create_autocmd("BufEnter", {pattern = "oil://*", callback = oil_cd_on_enter})
end
local function _7_()
end
local function _8_()
  return require("go").setup()
end
local function _9_()
  local cmp = require("cmp")
  local function _10_(args)
    return require("luasnip").lsp_expand(args.body)
  end
  return cmp.setup({snippet = {expand = _10_}, window = {completion = {winhighlight = "Normal:CmpNormal"}, documentation = {winhighlight = "Normal:CmpNormal"}}, mapping = cmp.mapping.preset.insert({["<C-b>"] = cmp.mapping.scroll_docs(-4), ["<C-f>"] = cmp.mapping.scroll_docs(4), ["<C-Space>"] = cmp.mapping.complete(), ["<C-e>"] = cmp.mapping.abort(), ["<CR>"] = cmp.mapping.confirm({select = true})}), sources = cmp.config.sources({{name = "nvim_lsp"}, {name = "conjure"}, {name = "luasnip"}}, {{name = "buffer"}})})
end
local function _11_()
  require("mason").setup()
  require("mason-lspconfig").setup({ensure_installed = {"elp", "marksman", "yamlls", "dockerls", "bashls", "gopls", "zls"}})
  require("mason-tool-installer").setup({ensure_installed = {"ada-language-server", "lua-language-server", "vim-language-server", "stylua", "shellcheck", "gofumpt", "golines", "gomodifytags", "gotests", "impl", "json-to-struct", "luacheck", "revive", "shellcheck", "shfmt", "staticcheck", "vint", "ruby-lsp", "clojure-lsp", "fennel_ls"}})
  local servers = {marksman = {}, yamlls = {}, clangd = {}, elp = {}, fennel_ls = {}, dockerls = {}, bashls = {}, rust_analyzer = {}, ["clojure-lsp"] = {}, ["ruby-lsp"] = {}, faustlsp = {}, zls = {}, gopls = {settings = {gopls = {analyses = {unusedparams = true}, staticcheck = true, gofumpt = true}}}, ["harper-ls"] = {settings = {["harper-ls"] = {SpellCheck = true, SentenceCapitalization = false}}}}
  for server, config in pairs(servers) do
    vim.lsp.enable(server, config)
  end
  local open_floating_preview = vim.lsp.util.open_floating_preview
  local function _12_(contents, syntax, opts, ...)
    local opts0 = (opts or {})
    opts0.border = (opts0.border or "rounded")
    return open_floating_preview(contents, syntax, opts0, ...)
  end
  vim.lsp.util.open_floating_preview = _12_
  return nil
end
local function _13_()
  local configs = require("nvim-treesitter.configs")
  return configs.setup({ensure_installed = {"ada", "bash", "erlang", "clojure", "fennel", "go", "haskell", "java", "javascript", "json", "lua", "markdown", "python", "toml", "xml", "yaml", "zig"}, highlight = {enable = true}, indent = {enable = true}, sync_install = false})
end
return {{"oonamo/ef-themes.nvim", priority = 1000, config = _1_, lazy = false, version = false}, {"Olical/nfnl", ft = "fennel"}, {"windwp/nvim-autopairs", event = "VeryLazy", config = true}, {"ibhagwan/fzf-lua", config = true}, {"smoka7/hop.nvim", version = "*", opts = {keys = "etovxqpdygfblzhckisuran"}}, {"nullchilly/fsread.nvim", version = "*", opts = {}, config = _2_}, {"andrewferrier/wrapping.nvim", version = "*", opts = {}, config = _3_}, {"folke/zen-mode.nvim", version = "*", opts = {}}, {"MeanderingProgrammer/render-markdown.nvim", version = "*", opts = {}}, {"stevearc/oil.nvim", config = _4_}, {"NeogitOrg/neogit", dependencies = {"nvim-lua/plenary.nvim", "sindrets/diffview.nvim"}, config = true}, {"akinsho/toggleterm.nvim", version = "*", config = true, opts = {direction = "horizontal", start_in_insert = true, float_opts = {border = "single", width = 200, height = 40}, shade_terminals = false}, lazy = false}, {"tidalcycles/vim-tidal", config = _7_}, {"ray-x/go.nvim", config = _8_, event = {"CmdlineEnter"}, ft = {"go", "gomod"}}, {"mrcjkb/rustaceanvim", version = "^6", lazy = false}, {"hrsh7th/nvim-cmp", dependencies = {"hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-vsnip"}, config = _9_}, {"neovim/nvim-lspconfig", event = "VeryLazy", dependencies = {"williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim", "WhoIsSethDaniel/mason-tool-installer.nvim"}, config = _11_}, {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate", config = _13_}, {"L3MON4D3/LuaSnip", dependencies = {"saadparwaiz1/cmp_luasnip"}}, {"tpope/vim-commentary", "tpope/vim-repeat", "tpope/vim-surround", "tpope/vim-sexp-mappings-for-regular-people"}, "guns/vim-sexp", "troydm/zoomwintab.vim", "hiphish/rainbow-delimiters.nvim", "julienvincent/nvim-paredit", "vim-erlang/vim-erlang-runtime", "ziglang/zig.vim", "mrcjkb/haskell-tools.nvim", "wsdjeg/vim-fetch", "olical/conjure", "mtmn/faust-nvim"}
