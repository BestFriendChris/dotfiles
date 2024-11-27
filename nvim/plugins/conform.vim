packadd! conform

lua <<EOF
require("conform").setup({
formatters_by_ft = {
  elixir = { "mix" , timeout_ms = 1500 },
},
format_on_save = {
  lsp_format = "fallback",
},
default_format_opts = {
  lsp_format = "fallback",
},
})

EOF
