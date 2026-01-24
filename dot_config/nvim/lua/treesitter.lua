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
  local filetype_set = {}
  for _, parser in ipairs(all_parsers) do
    for _0, filetype in ipairs(vim.treesitter.language.get_filetypes(parser)) do
      filetype_set[filetype] = true
    end
  end
  local function _2_()
    vim.treesitter.start()
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    return nil
  end
  return autocmd("FileType", {pattern = keys(filetype_set), callback = _2_})
end
return {build = build, config = config}
