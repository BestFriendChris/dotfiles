" Support command-c and command-v
vnoremap <D-c> "+y
nnoremap <D-v> "+P
vnoremap <D-v> "+P
cnoremap <D-v> <C-r>+
inoremap <D-v> <C-r>+
tnoremap <D-v> <C-\><C-n>"+pa

nnoremap <D-t> <Cmd>tabnew<CR>

if exists("g:neovide")
  set guifont=OperatorMonoSSm_Nerd_Font,Operator_Mono_SSm,Monaco:h14
  let g:neovide_cursor_animation_length=0.01
  set mousescroll=ver:3,hor:0
endif
