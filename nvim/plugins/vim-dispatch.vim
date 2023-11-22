packadd! vim-dispatch

function! s:DispatchGrep(args) abort
  let l:orig_makeprg = &l:makeprg
  let l:orig_errorformat = &l:errorformat

  let &l:makeprg=&grepprg
  let &l:errorformat=&grepformat

  exec 'Make ' a:args

  let &l:makeprg=l:orig_makeprg
  let &l:errorformat=l:orig_errorformat
endfunction

function! s:DispatchSetup() abort
  nnoremap <silent> `` <Cmd>Focus!<CR>

  command! -nargs=* Grep call <SID>DispatchGrep(<q-args>)
endfunction

call bfc#plugins#on_load(funcref('<SID>DispatchSetup'))

