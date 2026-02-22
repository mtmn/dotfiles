local _local_1_ = require("std.functional")
local map = _local_1_.map
local tbl = require("std.table")
local create_augroup = vim.api.nvim_create_augroup
local create_autocmd = vim.api.nvim_create_autocmd
local clear_autocmds = vim.api.nvim_clear_autocmds
local get_current_buf = vim.api.nvim_get_current_buf
create_augroup("local-lsp-auto-format", {clear = true})
local function is_array(tbl0)
  return not not tbl0[1]
end
local function map_vals(func, tbl0)
  local function _2_(_241, _242)
    return func(_242)
  end
  return map(_2_, tbl0)
end
local function create_auto_format_autocmd(extra_opts)
  local extra_opts0 = (extra_opts or {})
  local all_extra_opts
  if is_array(extra_opts0) then
    all_extra_opts = extra_opts0
  else
    all_extra_opts = {extra_opts0}
  end
  local all_opts
  local function _4_(_241)
    return tbl.merge({formatting_options = {timeout_ms = 5000}}, _241)
  end
  all_opts = map_vals(_4_, all_extra_opts)
  local auto_format_callback
  local function _5_()
    for _, opts in ipairs(all_opts) do
      vim.lsp.buf.format(opts)
    end
    return nil
  end
  auto_format_callback = _5_
  clear_autocmds({event = "BufWritePre", buffer = get_current_buf(), group = "local-lsp-auto-format"})
  create_autocmd("BufWritePre", {buffer = get_current_buf(), callback = auto_format_callback, group = "local-lsp-auto-format"})
  return nil
end
local function auto_format_on_save(filetypes, extra_opts)
  local callback
  local function _6_()
    return create_auto_format_autocmd(extra_opts)
  end
  callback = _6_
  for _, filetype in ipairs(filetypes) do
    create_autocmd("FileType", {pattern = filetype, callback = callback})
  end
  return nil
end
local function config()
  do
    local servers = {basedpyright = {}, clangd = {}, gopls = {settings = {gopls = {analyses = {unusedparams = true}, staticcheck = true, gofumpt = true}}}, intelephense = {}, rust_analyzer = {}, zls = {}}
    for server, config0 in pairs(servers) do
      vim.lsp.enable(server, config0)
    end
    local open_floating_preview = vim.lsp.util.open_floating_preview
    local function _7_(contents, syntax, opts, ...)
      local opts0 = (opts or {})
      opts0.border = (opts0.border or "rounded")
      return open_floating_preview(contents, syntax, opts0, ...)
    end
    vim.lsp.util.open_floating_preview = _7_
  end
  return vim.diagnostic.config({virtual_text = true})
end
return {["auto-format-on-save"] = auto_format_on_save, config = config}
