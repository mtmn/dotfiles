local opts = {noremap = true, silent = false}
local fzf_keymaps = {["<leader><leader>"] = "files", ["<leader>ff"] = "git_status", ["<leader>fh"] = "oldfiles", ["<leader>fg"] = "grep_project", ["<leader>b"] = "buffers"}
for key, func in pairs(fzf_keymaps) do
  vim.keymap.set("n", key, ("<cmd>lua require('fzf-lua')." .. func .. "()<CR>"))
end
local single_keymaps = {["<leader>g"] = "<cmd>Neogit<CR>", ["-"] = "<cmd>Oil<CR>", f = "<cmd>HopWord<CR>", mn = "<cmd>Mnav<CR>"}
for key, cmd in pairs(single_keymaps) do
  vim.keymap.set("n", key, cmd)
end
local lsp_keymaps = {["<leader>gg"] = "hover", ["<leader>gd"] = "definition", ["<leader>gD"] = "declaration", ["<leader>gi"] = "implementation", ["<leader>gt"] = "type_definition", ["<leader>gr"] = "references", ["<leader>gs"] = "signature_help", ["<leader>rr"] = "rename", ["<leader>ga"] = "code_action", ["<leader>tr"] = "document_symbol"}
for key, func in pairs(lsp_keymaps) do
  vim.keymap.set("n", key, ("<cmd>lua vim.lsp.buf." .. func .. "()<CR>"))
end
local function _1_()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(0, row, row, false, {"- [ ] "})
  return vim.api.nvim_win_set_cursor(0, {(row + 1), 5})
end
vim.keymap.set("n", "<leader>ta", _1_)
local function _2_()
  local line = vim.api.nvim_get_current_line()
  local new_line = nil
  if line:match("%[ %]") then
    new_line = line:gsub("%[ %]", "[-]", 1)
  elseif line:match("%[%-%]") then
    new_line = line:gsub("%[%-%]", "[x]", 1)
  elseif line:match("%[x%]") then
    new_line = line:gsub("%[x%]", "[ ]", 1)
  else
  end
  if new_line then
    return vim.api.nvim_set_current_line(new_line)
  else
    return nil
  end
end
vim.keymap.set("n", "<leader>tt", _2_)
local diagnostic_keymaps = {["<leader>gl"] = "open_float", ["<leader>gp"] = "goto_prev", ["<leader>gn"] = "goto_next"}
for key, func in pairs(diagnostic_keymaps) do
  vim.keymap.set("n", key, ("<cmd>lua vim.diagnostic." .. func .. "()<CR>"))
end
vim.keymap.set("v", "<leader>gf", "<cmd>lua vim.lsp.buf.format({async = true})<CR>")
vim.keymap.set("i", "<C-Space>", "<cmd>lua vim.lsp.buf.completion()<CR>")
return vim.keymap.set("n", "x", "\"_x")
