local function _1_()
  vim.bo.filetype = "text"
  vim.bo.syntax = "text"
  return nil
end
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {pattern = {"*.m3u", "*.m3u8"}, callback = _1_})
local function _2_(ev)
  return vim.lsp.buf.code_action({apply = true, context = {only = {"source.fixAll"}}})
end
vim.api.nvim_create_autocmd("BufWritePre", {callback = _2_, pattern = {"*.zig", "*.zon"}})
local function _3_()
  vim.opt_local.suffixesadd = ".md"
  vim.opt_local.includeexpr = "v:lua.follow_md_link()"
  local function _4_()
    return vim.v.fname:gsub("%[%[(.-)%]%]", "%1")
  end
  follow_md_link = _4_
  local function _5_()
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2]
    local link = line:match("%[([%w_%-][%w_%-]+)%]", col)
    if link then
      return vim.cmd(("edit " .. link .. ".md"))
    else
      return vim.cmd("normal! gf")
    end
  end
  return vim.keymap.set("n", "gf", _5_, {buffer = true})
end
return vim.api.nvim_create_autocmd("FileType", {pattern = "markdown", callback = _3_})
