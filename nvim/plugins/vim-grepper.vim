packadd! vim-grepper

function! s:GrepperSetup() abort
  let g:grepper = {}            " initialize g:grepper with empty dictionary
  runtime plugin/grepper.vim    " initialize g:grepper with default values

  let g:grepper.dir='filecwd'

  nmap gs <Plug>(GrepperOperator)
  xmap gs <Plug>(GrepperOperator)

  nnoremap <silent> <Leader>g <Cmd>Grepper -tool rg<CR>
  nnoremap <silent> <Leader>G <Cmd>Grepper -tool rg -dir file<CR>
  nnoremap <silent> <Leader>* <Cmd>Grepper -tool rg -cword -noprompt<CR>

  command! GrepTodo Grepper -noprompt -tool rg -query '(TODO|FIXME|XXX):'
endfunction

call bfc#plugins#on_load(funcref('<SID>GrepperSetup'))
