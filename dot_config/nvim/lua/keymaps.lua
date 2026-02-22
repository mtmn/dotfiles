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
local diagnostic_keymaps = {["<leader>gl"] = "open_float", ["<leader>gp"] = "goto_prev", ["<leader>gn"] = "goto_next"}
for key, func in pairs(diagnostic_keymaps) do
  vim.keymap.set("n", key, ("<cmd>lua vim.diagnostic." .. func .. "()<CR>"))
end
vim.keymap.set("v", "<leader>gf", "<cmd>lua vim.lsp.buf.format({async = true})<CR>")
vim.keymap.set("i", "<C-Space>", "<cmd>lua vim.lsp.buf.completion()<CR>")
return vim.keymap.set("n", "x", "\"_x")
