local function setup()
  require("mason").setup()
  return require("mason-tool-installer").setup({ensure_installed = {"basedpyright", "bash-debug-adapter", "bash-language-server", "bashls", "black", "buildifier", "codelldb", "dockerls", "fennel_ls", "gofumpt", "golines", "gomodifytags", "gopls", "gotests", "hadolint", "html", "impl", "intelephense", "json-to-struct", "lua-language-server", "luacheck", "pint", "revive", "rust_analyzer", "shellcheck", "shfmt", "starpls", "staticcheck", "stylua", "vint", "yamlls", "zls"}})
end
return {setup = setup}
