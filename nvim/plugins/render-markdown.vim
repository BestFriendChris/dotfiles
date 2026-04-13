packadd! render-markdown

lua <<EOF
require('render-markdown').setup({
    -- Whether markdown should be rendered by default.
    enabled = true,
    -- Vim modes that will show a rendered view of the markdown file, :h mode(), for all enabled
    -- components. Individual components can be enabled for other modes. Remaining modes will be
    -- unaffected by this plugin.
    render_modes = { 'n', 'c', 't' },
    -- Filetypes this plugin will run on.
    file_types = { 'markdown' },
    anti_conceal = { enabled = false, },
    heading = {
      position = "inline",
      width = "block",
      right_pad = 1,
    },
    code = {
      border = 'thick',
      position = 'right',
      language_icon = false,
      width = 'block',
      right_pad = 10,
    },
    latex = {
        enabled = false,
    },
    html = {
        comment = {
            conceal = false,
        },
    },
})
EOF

function! s:MarkdownSetup()
  nmap <buffer> <LocalLeader>d <CMD>s/\* \[.\]/* [x]/<CR>
  nmap <buffer> <LocalLeader>u <CMD>s/\* \[.\]/* [ ]/<CR>
  nmap <buffer> <LocalLeader>i <CMD>s/\* \[.\]/* [-]/<CR>
  nmap <buffer> <C-Enter> o* [ ]<Space>
  imap <buffer> <C-Enter> <CR>[ ]<Space>
endfunction

augroup bfcMarkdown
  autocmd!
  autocmd FileType markdown call s:MarkdownSetup()
augroup end
