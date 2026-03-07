local function _1_()
  vim.bo.filetype = "text"
  vim.bo.syntax = "text"
  return nil
end
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {pattern = {"*.m3u", "*.m3u8"}, callback = _1_})
do
  local group = vim.api.nvim_create_augroup("MagdalenaLogFile", {clear = true})
  local function _2_(ev)
    local filename = vim.api.nvim_buf_get_name(ev.buf)
    if (filename and (filename ~= "") and not filename:match("^oil://")) then
      local _job
      local function _3_(_, _0)
      end
      local function _4_(_, _0)
      end
      _job = vim.fn.jobstart({"magdalena", "log-file", filename}, {detach = true, on_stderr = _3_, on_exit = _4_})
      return nil
    else
      return nil
    end
  end
  vim.api.nvim_create_autocmd({"BufReadPost", "BufNewFile"}, {group = group, callback = _2_})
end
local function _6_(ev)
  return vim.lsp.buf.code_action({apply = true, context = {only = {"source.fixAll"}}})
end
vim.api.nvim_create_autocmd("BufWritePre", {callback = _6_, pattern = {"*.zig", "*.zon"}})
local function _7_()
  vim.opt_local.suffixesadd = ".md"
  vim.opt_local.includeexpr = "v:lua.follow_md_link()"
  local function _8_()
    return vim.v.fname:gsub("%[%[(.-)%]%]", "%1")
  end
  follow_md_link = _8_
  local function _9_()
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2]
    local link = line:match("%[([%w_%-][%w_%-]+)%]", col)
    if link then
      return vim.cmd(("edit " .. link .. ".md"))
    else
      return vim.cmd("normal! gf")
    end
  end
  return vim.keymap.set("n", "gf", _9_, {buffer = true})
end
return vim.api.nvim_create_autocmd("FileType", {pattern = "markdown", callback = _7_})
