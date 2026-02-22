local function config()
  local cmp = require("cmp")
  local function _1_(args)
    return require("luasnip").lsp_expand(args.body)
  end
  return cmp.setup({snippet = {expand = _1_}, window = {completion = {winhighlight = "Normal:CmpNormal"}, documentation = {winhighlight = "Normal:CmpNormal"}}, mapping = cmp.mapping.preset.insert({["ctrl-b"] = cmp.mapping.scroll_docs(-4), ["ctrl-f"] = cmp.mapping.scroll_docs(4), ["ctrl-space"] = cmp.mapping.complete(), ["ctrl-e"] = cmp.mapping.abort(), enter = cmp.mapping.confirm({select = true})}), sources = cmp.config.sources({{name = "nvim_lsp"}, {name = "luasnip"}, {name = "path"}}, {{name = "buffer"}})})
end
return {config = config}
