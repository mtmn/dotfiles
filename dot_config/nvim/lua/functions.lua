local home = os.getenv("HOME")
local function log_file_event(action)
  local file_path = vim.fn.expand("%:p")
  if ((file_path ~= "") and (file_path ~= nil)) then
    local db_path = (vim.fn.expand("$HOME") .. "/.magnolia.db")
    local escaped_path = file_path:gsub("'", "''")
    local sql_query = string.format("INSERT INTO file_history (path, file_type, action) VALUES ('%s', '%s', '%s');", escaped_path, __fnl_global__file_2dtype, action)
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
  vim.bo.filetype = "m3u"
  vim.bo.syntax = "m3u"
  return nil
end
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {pattern = {"*.m3u", "*.m3u8"}, callback = _4_})
local function _5_()
  vim.bo.filetype = "m3u"
  vim.bo.syntax = "m3u"
  return nil
end
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {pattern = (vim.fn.expand("$HOME") .. "/misc/notes/releases/*"), callback = _5_})
local function _6_(ev)
  return vim.lsp.buf.code_action({apply = true, context = {only = {"source.fixAll"}}})
end
return vim.api.nvim_create_autocmd("BufWritePre", {callback = _6_, pattern = {"*.zig", "*.zon"}})
