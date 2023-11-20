packadd! vim-dispatch


function! s:DispatchSetup() abort
  nnoremap <silent> `` <Cmd>Focus!<CR>
endfunction

call bfc#plugins#on_load(funcref('<SID>DispatchSetup'))

