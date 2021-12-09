set ignorecase
set smartcase
set switchbuf=useopen,usetab,uselast
set softtabstop=2
set shiftwidth=2
set expandtab
set winminheight=0
set splitbelow
set scrolloff=2
set nowrap
set linebreak
set number
set relativenumber
set visualbell
set wildmode=list:longest

let maplocalleader=","

nnoremap * /\C\<<C-R>=expand('<cword>')<CR>\><CR>
nnoremap # ?\C\<<C-R>=expand('<cword>')<CR>\><CR>

inoremap jk <ESC>

filetype plugin indent on
syntax on
