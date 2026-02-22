local function config()
  local blink = require("blink.cmp")
  return blink.setup({snippets = {preset = "luasnip"}, appearance = {nerd_font_variant = "none"}, keymap = {preset = "none", ["<C-p>"] = {"select_prev", "fallback"}, ["<C-n>"] = {"select_next", "fallback"}, ["<C-b>"] = {"scroll_documentation_up", "fallback"}, ["<C-f>"] = {"scroll_documentation_down", "fallback"}, ["<C-Space>"] = {"show", "show_documentation", "hide_documentation"}, ["<C-e>"] = {"hide", "fallback"}, ["<CR>"] = {"accept", "fallback"}}, completion = {menu = {winhighlight = "Normal:CmpNormal"}, documentation = {auto_show = true, window = {winhighlight = "Normal:CmpNormal"}}}, sources = {default = {"lsp", "snippets", "path", "buffer"}}})
end
return {config = config}
