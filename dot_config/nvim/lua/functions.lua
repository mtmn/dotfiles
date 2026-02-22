local home = os.getenv("HOME")
local function log_file_event(action)
  local file_path = vim.fn.expand("%:p")
  if ((file_path ~= "") and (file_path ~= nil)) then
    local db_path = (vim.fn.expand("$HOME") .. "/.magnolia.db")
    local escaped_path = file_path:gsub("'", "''")
    local sql_query = string.format("DELETE FROM file_history WHERE path LIKE 'oil://%%'; INSERT INTO file_history (path, file_type, action) VALUES ('%s', '%s', '%s');", escaped_path, __fnl_global__file_2dtype, action)
    local command = string.format("sqlite3 '%s' \"%s\"", db_path, sql_query)
    return vim.fn.system(command)
  else
    return nil
  end
end
do
  local augroup = vim.api.nvim_create_augroup("FzfFileHistory", {clear = true})
  local function _2_()
    return log_file_event("open")
  end
  vim.api.nvim_create_autocmd({"BufReadPost"}, {group = augroup, pattern = "*", callback = _2_})
  local function _3_()
    return log_file_event("open")
  end
  vim.api.nvim_create_autocmd({"BufWritePost"}, {group = augroup, pattern = "*", callback = _3_})
end
local function _4_()
  vim.bo.filetype = "text"
  vim.bo.syntax = "text"
  return nil
end
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {pattern = {"*.m3u", "*.m3u8"}, callback = _4_})
local function _5_(ev)
  return vim.lsp.buf.code_action({apply = true, context = {only = {"source.fixAll"}}})
end
vim.api.nvim_create_autocmd("BufWritePre", {callback = _5_, pattern = {"*.zig", "*.zon"}})
local function _6_()
  vim.opt_local.suffixesadd = ".md"
  vim.opt_local.includeexpr = "v:lua.follow_md_link()"
  local function _7_()
    return vim.v.fname:gsub("%[%[(.-)%]%]", "%1")
  end
  follow_md_link = _7_
  local function _8_()
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2]
    local link = line:match("%[([%w_%-][%w_%-]+)%]", col)
    if link then
      return vim.cmd(("edit " .. link .. ".md"))
    else
      return vim.cmd("normal! gf")
    end
  end
  return vim.keymap.set("n", "gf", _8_, {buffer = true})
end
return vim.api.nvim_create_autocmd("FileType", {pattern = "markdown", callback = _6_})
