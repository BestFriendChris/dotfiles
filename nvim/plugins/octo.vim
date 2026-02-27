packadd! octo

lua << EOF
require"octo".setup({
  enable_builtin = true,
  file_panel = {
    use_icons = false,
  },
})

vim.cmd([[hi OctoEditable guibg=none]])
EOF

nmap <Leader>o <Cmd>Octo<CR>

