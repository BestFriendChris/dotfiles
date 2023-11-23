packadd! bqf

lua << EOF
require('bqf').setup({
  func_map = {
    tabdrop = '<C-t>',
    tabc = '',
  }
})
EOF
