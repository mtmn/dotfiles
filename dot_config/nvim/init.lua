-- [nfnl] Compiled from fnl/init.fnl by https://github.com/Olical/nfnl, do not edit.
-- Optimize Lua loading
vim.loader.enable()
local _local_1_ = vim
local g = _local_1_["g"]
local env = _local_1_["env"]
local fs = _local_1_["fs"]
local _local_2_ = vim.api
local command = _local_2_["nvim_command"]
local _local_3_ = vim.fn
local stdpath = _local_3_["stdpath"]
local empty = _local_3_["empty"]
local glob = _local_3_["glob"]
local _local_4_ = string
local format = _local_4_["format"]
local function bootstrap_lazy()
  local lazypath = (vim.fn.stdpath("data") .. "/lazy/lazy.nvim")
  if not vim.uv.fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({"git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath})
    if (vim.v.shell_error ~= 0) then
      vim.api.nvim_echo({{"Failed to clone lazy.nvim:\n", "ErrorMsg"}, {out}, {"\nPress any key to exit..."}}, true, {})
      vim.fn.getchar()
      os.exit(1)
    else
    end
  else
  end
  vim.opt.rtp:prepend(lazypath)
  return require("lazy")
end
local function plugin_specs()
  local function use(name, opts)
    local opts0 = (opts or {})
    opts0[1] = name
    return opts0
  end
  return {use("oonamo/ef-themes.nvim", {config = function()
    vim.opt.background = "dark"
    return vim.cmd.colorscheme("ef-tritanopia-dark")
  end, lazy = false, priority = 1000, version = false}), use("windwp/nvim-autopairs", {config = true, event = "VeryLazy"}), use("ibhagwan/fzf-lua", {config = true}), use("smoka7/hop.nvim", {opts = {keys = "etovxqpdygfblzhckisuran"}, version = "*"}), use("Olical/nfnl", {ft = "fennel"}), use("nullchilly/fsread.nvim", {config = function()
    vim.g.flow_strength = 0.7
    vim.api.nvim_set_hl(0, "FSPrefix", {fg = "#cdd6f4"})
    return vim.api.nvim_set_hl(0, "FSSuffix", {fg = "#6C7086"})
  end, opts = {}, version = "*"}), use("MeanderingProgrammer/render-markdown.nvim", {opts = {}, version = "*"}), use("stevearc/oil.nvim", {config = function()
    require("oil").setup({view_options = {show_hidden = false}})
    local oil_cd_on_enter
    local function _3_()
      local oil = require("oil")
      local current_dir = oil.get_current_dir()
      if current_dir then
        return vim.cmd(("cd " .. current_dir))
      else
        return nil
      end
    end
    oil_cd_on_enter = _3_
    return vim.api.nvim_create_autocmd("BufEnter", {callback = oil_cd_on_enter, pattern = "oil://*"})
  end}), use("NeogitOrg/neogit", {config = true, dependencies = {"nvim-lua/plenary.nvim", "sindrets/diffview.nvim"}}), use("ray-x/go.nvim", {config = function()
    return require("go").setup()
  end, event = {"CmdlineEnter"}, ft = {"go", "gomod"}}), use("mrcjkb/rustaceanvim", {lazy = false, version = "^6"}), use("hrsh7th/nvim-cmp", {config = function()
    local cmp = require("cmp")
    local function _5_(args)
      return require("luasnip").lsp_expand(args.body)
    end
    return cmp.setup({mapping = cmp.mapping.preset.insert({["ctrl-b"] = cmp.mapping.scroll_docs(-4), ["ctrl-e"] = cmp.mapping.abort(), ["ctrl-f"] = cmp.mapping.scroll_docs(4), ["ctrl-space"] = cmp.mapping.complete(), enter = cmp.mapping.confirm({select = true})}), snippet = {expand = _5_}, sources = cmp.config.sources({ {name = "nvim_lsp"}, {name = "luasnip"}, {name = "path"}}, { {name = "buffer"}}), window = {completion = {winhighlight = "Normal:CmpNormal"}, documentation = {winhighlight = "Normal:CmpNormal"}}})
  end, dependencies = {"hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "hrsh7th/cmp-vsnip"}}), use("neovim/nvim-lspconfig", {branch = "master", config = function()
    require("mason").setup()
    require("mason-lspconfig").setup({ensure_installed = {"basedpyright", "bashls", "dockerls", "gopls", "phpactor", "yamlls"}})
    require("mason-tool-installer").setup({ensure_installed = {"black", "gofumpt", "golines", "gomodifytags", "gotests", "impl", "json-to-struct", "lua-language-server", "luacheck", "phpactor", "revive", "shellcheck", "shfmt", "staticcheck", "stylua", "vint"}})
    local servers = {basedpyright = {}, bashls = {}, clangd = {}, dockerls = {}, gopls = {settings = {gopls = {analyses = {unusedparams = true}, gofumpt = true, staticcheck = true}}}, phpactor = {}, rust_analyzer = {}, yamlls = {}, zls = {}}
    for server, config in pairs(servers) do
      vim.lsp.enable(server, config)
    end
    local open_floating_preview = vim.lsp.util.open_floating_preview
    local function _6_(contents, syntax, opts, ...)
      local opts0 = (opts or {})
      opts0.border = (opts0.border or "rounded")
      return open_floating_preview(contents, syntax, opts0, ...)
    end
    vim.lsp.util.open_floating_preview = _6_
    return nil
  end, dependencies = {"williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim", "WhoIsSethDaniel/mason-tool-installer.nvim"}, event = "VeryLazy"}), use("nvim-treesitter/nvim-treesitter", {branch = "main", build = function()
    local _7_ = require("treesitter")
    return _7_["build"](_7_)
  end, config = function()
    local _8_ = require("treesitter")
    return _8_["config"](_8_)
  end}), use("L3MON4D3/LuaSnip", {dependencies = {"saadparwaiz1/cmp_luasnip"}}), use("tpope/vim-commentary"), use("tpope/vim-repeat"), use("tpope/vim-surround"), use("troydm/zoomwintab.vim")}
end
local function init()
  local vimrc = (vim.fn.stdpath("config") .. "/init_.vim")
  vim.cmd.source(vimrc)
  vim.opt.clipboard = "unnamedplus"
  package.path = (fs.normalize("~") .. "/.config/nvim/lua/?.lua," .. package.path)
  local lazy = bootstrap_lazy()
  lazy.setup({checker = {enabled = false}, spec = plugin_specs()})
  for _, module in ipairs({"aliases", "keymaps", "functions"}) do
    require(module)
  end
  return nil
end
if not g.vscode then
  init()
else
end
return nil
