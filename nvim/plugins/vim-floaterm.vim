packadd! vim-floaterm

let g:floaterm_width=0.9
let g:floaterm_height=0.9
let g:floaterm_autoclose=1
let g:floaterm_opener='tabe'

augroup FloatermCustomisations
    autocmd!
    autocmd ColorScheme * highlight FloatermBorder guibg=none
augroup END

tnoremap <C-Q><C-Q> <C-\><C-n><Cmd>FloatermToggle<CR>
nnoremap <C-Q><C-Q> <Cmd>FloatermToggle<CR>

tnoremap <C-Q><C-F> <C-\><C-n><Cmd>FloatermNew<CR>
nnoremap <C-Q><C-F> <Cmd>FloatermNew<CR>

tnoremap <C-Q><C-N> <C-\><C-n><Cmd>FloatermNext<CR>
nnoremap <C-Q><C-N> <Cmd>FloatermNext<CR>

tnoremap <C-Q><C-P> <C-\><C-n><Cmd>FloatermPrev<CR>
nnoremap <C-Q><C-P> <Cmd>FloatermPrev<CR>
