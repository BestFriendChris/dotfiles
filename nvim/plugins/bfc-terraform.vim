
function! s:BfcTerraformSetup() abort
  lua <<EOF
  require'lspconfig'.terraformls.setup{}
EOF

  autocmd BufWritePre *.tfvars lua vim.lsp.buf.format()
  autocmd BufWritePre *.tf     lua vim.lsp.buf.format()
endfunction

call bfc#plugins#on_load(funcref('<SID>BfcTerraformSetup'))
