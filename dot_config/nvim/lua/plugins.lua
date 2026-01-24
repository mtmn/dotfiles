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
  require("oil").setup({view_options = {show_hidden = false}})
  local oil_cd_on_enter
  local function _4_()
    local oil = require("oil")
    local current_dir = oil.get_current_dir()
    if current_dir then
      return vim.cmd(("cd " .. current_dir))
    else
      return nil
    end
  end
  oil_cd_on_enter = _4_
  return vim.api.nvim_create_autocmd("BufEnter", {pattern = "oil://*", callback = oil_cd_on_enter})
end
local function _6_()
  return require("go").setup()
end
local function _7_()
  local cmp = require("cmp")
  local function _8_(args)
    return require("luasnip").lsp_expand(args.body)
  end
  return cmp.setup({snippet = {expand = _8_}, window = {completion = {winhighlight = "Normal:CmpNormal"}, documentation = {winhighlight = "Normal:CmpNormal"}}, mapping = cmp.mapping.preset.insert({["ctrl-b"] = cmp.mapping.scroll_docs(-4), ["ctrl-f"] = cmp.mapping.scroll_docs(4), ["ctrl-space"] = cmp.mapping.complete(), ["ctrl-e"] = cmp.mapping.abort(), enter = cmp.mapping.confirm({select = true})}), sources = cmp.config.sources({{name = "nvim_lsp"}, {name = "luasnip"}, {name = "path"}}, {{name = "buffer"}})})
end
local function _9_()
  require("mason").setup()
  require("mason-lspconfig").setup({ensure_installed = {"basedpyright", "bashls", "dockerls", "gopls", "phpactor", "yamlls"}})
  require("mason-tool-installer").setup({ensure_installed = {"black", "gofumpt", "golines", "gomodifytags", "gotests", "impl", "json-to-struct", "lua-language-server", "luacheck", "phpactor", "revive", "shellcheck", "shfmt", "staticcheck", "stylua", "vint"}})
  local servers = {basedpyright = {}, bashls = {}, clangd = {}, dockerls = {}, gopls = {settings = {gopls = {analyses = {unusedparams = true}, staticcheck = true, gofumpt = true}}}, phpactor = {}, rust_analyzer = {}, yamlls = {}, zls = {}}
  for server, config in pairs(servers) do
    vim.lsp.enable(server, config)
  end
  local open_floating_preview = vim.lsp.util.open_floating_preview
  local function _10_(contents, syntax, opts, ...)
    local opts0 = (opts or {})
    opts0.border = (opts0.border or "rounded")
    return open_floating_preview(contents, syntax, opts0, ...)
  end
  vim.lsp.util.open_floating_preview = _10_
  return nil
end
return {{"oonamo/ef-themes.nvim", priority = 1000, config = _1_, lazy = false, version = false}, {"windwp/nvim-autopairs", event = "VeryLazy", config = true}, {"ibhagwan/fzf-lua", config = true}, {"smoka7/hop.nvim", version = "*", opts = {keys = "etovxqpdygfblzhckisuran"}}, {"Olical/nfnl", ft = "fennel"}, {"nullchilly/fsread.nvim", version = "*", opts = {}, config = _2_}, {"MeanderingProgrammer/render-markdown.nvim", version = "*", opts = {}}, {"stevearc/oil.nvim", config = _3_}, {"NeogitOrg/neogit", dependencies = {"nvim-lua/plenary.nvim", "sindrets/diffview.nvim"}, config = true}, {"ray-x/go.nvim", config = _6_, event = {"CmdlineEnter"}, ft = {"go", "gomod"}}, {"mrcjkb/rustaceanvim", version = "^6", lazy = false}, {"hrsh7th/nvim-cmp", dependencies = {"hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "hrsh7th/cmp-vsnip"}, config = _7_}, {"neovim/nvim-lspconfig", event = "VeryLazy", branch = "master", dependencies = {"williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim", "WhoIsSethDaniel/mason-tool-installer.nvim"}, config = _9_}, {{"nvim-treesitter/nvim-treesitter", branch = "main", build = ":TSUpdate"}, {"L3MON4D3/LuaSnip", dependencies = {"saadparwaiz1/cmp_luasnip"}}, "tpope/vim-commentary", "tpope/vim-repeat", "tpope/vim-surround", "troydm/zoomwintab.vim"}}
