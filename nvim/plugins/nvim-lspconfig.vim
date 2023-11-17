packadd! nvim-lspconfig

function! s:LspConfigSetup() abort
  nnoremap <Leader>do <Cmd>lua vim.diagnostic.open_float()<CR>
  nnoremap [d <Cmd>lua vim.diagnostic.goto_prev()<CR>
  nnoremap ]d <Cmd>lua vim.diagnostic.goto_next()<CR>
  nnoremap <Leader>dq <Cmd>lua vim.diagnostic.setloclist()<CR>

lua <<EOF
-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<Leader>do', "<Cmd>lua vim.diagnostic.open_float()<CR>")
vim.keymap.set('n', '[d', "<Cmd>lua vim.diagnostic.goto_prev()<CR>")
vim.keymap.set('n', ']d', "<Cmd>lua vim.diagnostic.goto_next()<CR>")
vim.keymap.set('n', '<Leader>dl', "<Cmd>lua vim.diagnostic.setloclist()<CR>")
vim.keymap.set('n', '<Leader>dq', "<Cmd>lua vim.diagnostic.setqflist()<CR>")

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    vim.keymap.set('n', 'gd', "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
    vim.keymap.set('n', 'gi', "<Cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    vim.keymap.set('n', 'gr', "<Cmd>lua vim.lsp.buf.references()<CR>", opts)
    vim.keymap.set('n', 'K', "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
    vim.keymap.set('n', '<LocalLeader>lsh', "<Cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    vim.keymap.set('n', '<LocalLeader>lwa', "<Cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
    vim.keymap.set('n', '<LocalLeader>lwr', "<Cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
    vim.keymap.set('n', '<LocalLeader>lwl', "<Cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
    vim.keymap.set('n', '<LocalLeader>lD', "<Cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
    vim.keymap.set('n', '<LocalLeader>lrn', "<Cmd>lua vim.lsp.buf.rename()<CR>", opts)
    vim.keymap.set({ 'n', 'v' }, '<LocalLeader>ca', "<Cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    vim.keymap.set('n', '<LocalLeader>lf', "<Cmd>lua vim.lsp.buf.format { async = true }<CR>", opts)
  end,
})
EOF
endfunction

call bfc#plugins#on_load(funcref('<SID>LspConfigSetup'))
