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
    require("oil").setup({view_options = {show_hidden = false}})
    local oil_cd_on_enter
    local function _5_()
      local oil = require("oil")
      local current_dir = oil.get_current_dir()
      if current_dir then
        return vim.cmd(("cd " .. current_dir))
      else
        return nil
      end
    end
    oil_cd_on_enter = _5_
    return vim.api.nvim_create_autocmd("BufEnter", {pattern = "oil://*", callback = oil_cd_on_enter})
  end
  local function _7_()
    return require("config.blink"):config()
  end
  local function _8_()
    return require("config.lsp"):config()
  end
  local function _9_()
    return require("config.treesitter"):build()
  end
  local function _10_()
    return require("config.treesitter"):config()
  end
  local function _11_()
    vim.opt.rtp:prepend((vim.fn.stdpath("data") .. "/lazy/prr/vim"))
    return vim.filetype.add({extension = {prr = "prr"}})
  end
  return {use("oonamo/ef-themes.nvim", {priority = 1000, config = _3_, lazy = false, version = false}), use("windwp/nvim-autopairs", {event = "VeryLazy", config = true}), use("ibhagwan/fzf-lua", {config = true}), use("smoka7/hop.nvim", {version = "*", opts = {keys = "etovxqpdygfblzhckisuran"}}), use("stevearc/oil.nvim", {config = _4_}), use("neogitorg/neogit", {dependencies = {"nvim-lua/plenary.nvim", "sindrets/diffview.nvim"}, config = true}), use("saghen/blink.cmp", {version = "^1", dependencies = {"L3MON4D3/LuaSnip"}, config = _7_, lazy = false}), use("mrcjkb/rustaceanvim", {version = "^7", lazy = false}), use("neovim/nvim-lspconfig", {event = "VeryLazy", branch = "master", config = _8_}), use("nvim-treesitter/nvim-treesitter", {branch = "main", build = _9_, config = _10_}), use("tpope/vim-commentary"), use("tpope/vim-repeat"), use("tpope/vim-surround"), use("troydm/zoomwintab.vim"), use("danobi/prr", {init = _11_})}
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
