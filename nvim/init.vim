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

"--------------------------------------------------------------------------------
" MAPPINGS
"--------------------------------------------------------------------------------

" Don't use Ex mode, use Q for quitting when saved
nmap Q :q<CR>
nmap <Leader>Q :bw<CR>

" Navigate between windows easier
map <C-J> <C-W>j
map <C-K> <C-W>k

" Navigate between tabs
map <C-H> gT
map <C-L> gt
map <silent> g<C-H> :tabmove -1<CR>
map <silent> g<C-L> :tabmove +1<CR>

" Toggle line wrapping
nmap <silent> <C-W><C-W> :setlocal invwrap<CR>

" Select some text and search with it
vmap // y/\V<C-R>"<CR>
vmap ?? y?\V<C-R>"<CR>

" Wrapped line movement
map <Up> gk
map <Down> gj

" Execute macro in the 'q' register
map <C-Q> @q

" More useful mappings to find the latest { or }
nmap [[ [{
nmap ]] ]}

" j/k
inoremap jk <ESC>
cnoremap jk <C-c>

" Break undo sequence on newline or C-U line clearing
inoremap <CR> <C-G>u<CR>
inoremap <C-U> <C-G>u<C-U>

" Shift-Return will break undo and open the line above
inoremap <S-CR> <C-G>u<ESC>O

" hate-hate-hate using K to open a man page
nmap K <Nop>

" Stop accidently hitting <F1>
nmap <F1> <Nop>
nmap <D-F1> <Nop>

" Save the file easier
nmap <silent> <Leader>w :w<CR>
nmap <silent> <Leader>W :wa<CR>

" Magic voodoo that changes %% into the path of the current file in cmd mode
cnoremap %% <C-R>=expand('%:h').'/'<CR>

" Swap buffers
nmap <Leader><Leader> <C-^>

" Use 'very-magic' searching
nnoremap g/ /\v

" Open tag in new tab
nnoremap <Leader>] :tab stjump <C-R><C-W><CR>
" Open tag in preview
nnoremap <Leader>[ :ptjump <C-R><C-W><CR>

" Toggle fold
nnoremap z<Space> zA

" Toggle winheight
nnoremap <silent> <C-W><Space> :let &winheight=( &winheight == 999 ? 1 : 999)<CR><C-W>=

nnoremap * /\C\<<C-R>=expand('<cword>')<CR>\><CR>
nnoremap # ?\C\<<C-R>=expand('<cword>')<CR>\><CR>

nnoremap gf :e <cfile><CR>
nnoremap ^wgf :tabe <cfile><CR>

nnoremap <Leader><Space> <Cmd>nohlsearch<Bar>diffupdate<CR><C-L>

nmap <Leader>ve :edit ~/.config/nvim/init.vim<CR>
nmap <Leader>vr :source ~/.config/nvim/init.vim<CR>

" Reselect visual selection after indenting
vnoremap < <gv
vnoremap > >gv

" Maintain the cursor position when yanking a visual selection
" http://ddrscott.github.io/blog/2016/yank-without-jank/
vnoremap y myy`y
vnoremap Y myY`y

" Paste replace visual selection without copying it
vnoremap <Leader>p "_dP

"--------------------------------------------------------------------------------
" AUTOCMD
"--------------------------------------------------------------------------------

" For all text files set 'textwidth' to 78 characters
autocmd FileType text setlocal textwidth=78

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

"--------------------------------------------------------------------------------
" PLUGINS
"--------------------------------------------------------------------------------

source ~/.config/nvim/plugins.vim

"--------------------------------------------------------------------------------
" FINISH
"--------------------------------------------------------------------------------

filetype plugin indent on
syntax on

doautocmd User PackagesLoaded
