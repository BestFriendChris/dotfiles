packadd! zig.vim

lua << EOF
local lspconfig = require('lspconfig')
lspconfig.zls.setup{}

local config = {
  ["build.zig"] = {
    ["*.zig"] = {
      dispatch = "zig test {}.zig",
      template = {
        "package {dirname|basename}",
      },
    },
  },
}
local new_heuristics
if vim.g.projectionist_heuristics then
  new_heuristics = vim.tbl_extend("force", vim.g.projectionist_heuristics, config)
else
  new_heuristics = config
end
vim.g.projectionist_heuristics = new_heuristics
EOF
