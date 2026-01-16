-- [nfnl] functions.fnl
local home = os.getenv("HOME")
local secrets = require("secrets")
local function navigate_to_dir()
  local current_line = vim.api.nvim_get_current_line()
  local clean_line
  if (current_line:sub(-1) == "/") then
    clean_line = current_line:sub(1, -2)
  else
    clean_line = current_line
  end
  local full_path = (home .. secrets.magnolia .. clean_line)
  vim.fn.chdir(full_path)
  vim.cmd("ToggleTerm")
  return vim.cmd("cd ~")
end
local function play_dir_in_fooyin()
  local current_line = vim.api.nvim_get_current_line()
  local clean_line
  if (current_line:sub(-1) == "/") then
    clean_line = current_line:sub(1, -2)
  else
    clean_line = current_line
  end
  local full_path = (home .. secrets.magnolia .. clean_line)
  vim.fn.chdir(full_path)
  vim.system({"fooyin", full_path}, {detach = true})
  return vim.cmd("cd ~")
end
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
  local function _4_()
    return log_file_event("open")
  end
  vim.api.nvim_create_autocmd({"BufReadPost"}, {group = augroup, pattern = "*", callback = _4_})
  local function _5_()
    return log_file_event("open")
  end
  vim.api.nvim_create_autocmd({"BufWritePost"}, {group = augroup, pattern = "*", callback = _5_})
end
vim.api.nvim_create_user_command("Mnav", navigate_to_dir, {})
vim.api.nvim_create_user_command("Mfoo", play_dir_in_fooyin, {})
local function _6_()
  vim.bo.filetype = "m3u"
  vim.bo.syntax = "m3u"
  return nil
end
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {pattern = {"*.m3u", "*.m3u8"}, callback = _6_})
local function _7_()
  vim.bo.filetype = "m3u"
  vim.bo.syntax = "m3u"
  return nil
end
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {pattern = (vim.fn.expand("$HOME") .. "/misc/notes/releases/*"), callback = _7_})
local function _8_(ev)
  return vim.lsp.buf.code_action({apply = true, context = {only = {"source.fixAll"}}})
end
return vim.api.nvim_create_autocmd("BufWritePre", {callback = _8_, pattern = {"*.zig", "*.zon"}})
