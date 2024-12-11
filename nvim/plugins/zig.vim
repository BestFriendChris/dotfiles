packadd! zig.vim

lua << EOF
local lspconfig = require('lspconfig')
lspconfig.zls.setup{}
EOF
