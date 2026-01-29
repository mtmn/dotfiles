local command = vim.api.nvim_command
local autocmd = vim.api.nvim_create_autocmd
local _local_1_ = require("std.table")
local keys = _local_1_.keys
local ts = require("nvim-treesitter")
local all_parsers = keys(require("nvim-treesitter.parsers"))
local function build()
  ts.install(all_parsers):wait(300000)
  return ts.update(all_parsers):wait(300000)
end
local function config()
  local parsers = require("nvim-treesitter.parsers")
  local function _2_()
    local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
    if (lang and pcall(vim.treesitter.get_parser, 0, lang)) then
      vim.treesitter.start()
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      return nil
    else
      return nil
    end
  end
  return autocmd("FileType", {callback = _2_})
end
return {build = build, config = config}
