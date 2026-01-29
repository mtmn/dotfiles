vim.loader.enable()
local g = vim.g
local env = vim.env
local fs = vim.fs
local command = vim.api.nvim_command
local stdpath = vim.fn.stdpath
local empty = vim.fn.empty
local glob = vim.fn.glob
local format = string.format
local function bootstrap_lazy()
  local lazypath = (vim.fn.stdpath("data") .. "/lazy/lazy.nvim")
  if not vim.uv.fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({"git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath})
    if (vim.v.shell_error ~= 0) then
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
  local function _3_()
    vim.opt.background = "dark"
    return vim.cmd.colorscheme("ef-tritanopia-dark")
  end
  local function _4_()
    vim.g.flow_strength = 0.7
    vim.api.nvim_set_hl(0, "FSPrefix", {fg = "#cdd6f4"})
    return vim.api.nvim_set_hl(0, "FSSuffix", {fg = "#6C7086"})
  end
  local function _5_()
    require("oil").setup({view_options = {show_hidden = false}})
    local oil_cd_on_enter
    local function _6_()
      local oil = require("oil")
      local current_dir = oil.get_current_dir()
      if current_dir then
        return vim.cmd(("cd " .. current_dir))
      else
        return nil
      end
    end
    oil_cd_on_enter = _6_
    return vim.api.nvim_create_autocmd("BufEnter", {pattern = "oil://*", callback = oil_cd_on_enter})
  end
  local function _8_()
    return require("go").setup()
  end
  local function _9_()
    return require("config.cmp"):config()
  end
  local function _10_()
    require("config.mason"):setup()
    return require("config.lsp"):config()
  end
  local function _11_()
    return require("config.treesitter"):build()
  end
  local function _12_()
    return require("config.treesitter"):config()
  end
  return {use("oonamo/ef-themes.nvim", {priority = 1000, config = _3_, lazy = false, version = false}), use("windwp/nvim-autopairs", {event = "VeryLazy", config = true}), use("ibhagwan/fzf-lua", {config = true}), use("smoka7/hop.nvim", {version = "*", opts = {keys = "etovxqpdygfblzhckisuran"}}), use("nullchilly/fsread.nvim", {version = "*", opts = {}, config = _4_}), use("MeanderingProgrammer/render-markdown.nvim", {version = "*", opts = {}}), use("stevearc/oil.nvim", {config = _5_}), use("NeogitOrg/neogit", {dependencies = {"nvim-lua/plenary.nvim", "sindrets/diffview.nvim"}, config = true}), use("ray-x/go.nvim", {config = _8_, event = {"CmdlineEnter"}, ft = {"go", "gomod"}}), use("mrcjkb/rustaceanvim", {version = "^7", lazy = false}), use("hrsh7th/nvim-cmp", {dependencies = {"hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "hrsh7th/cmp-vsnip"}, config = _9_}), use("neovim/nvim-lspconfig", {event = "VeryLazy", branch = "master", dependencies = {"williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim", "WhoIsSethDaniel/mason-tool-installer.nvim"}, config = _10_}), use("nvim-treesitter/nvim-treesitter", {branch = "main", build = _11_, config = _12_}), use("L3MON4D3/LuaSnip", {dependencies = {"saadparwaiz1/cmp_luasnip"}}), use("tpope/vim-commentary"), use("tpope/vim-repeat"), use("tpope/vim-surround"), use("troydm/zoomwintab.vim")}
end
local function init()
  do
    local vimrc = (vim.fn.stdpath("config") .. "/init_.vim")
    vim.cmd.source(vimrc)
  end
  vim.opt.clipboard = "unnamedplus"
  package.path = (fs.normalize("~") .. "/.config/nvim/lua/?.lua," .. package.path)
  local lazy = bootstrap_lazy()
  lazy.setup({spec = plugin_specs(), checker = {enabled = false}})
  for _, module in ipairs({"aliases", "keymaps", "functions"}) do
    require(module)
  end
  return nil
end
return init()
