packadd! vim-wheel

let g:wheel#map#up = ''
let g:wheel#map#down = ''

function! s:ToggleWheel() abort
  if !exists('b:wheel_enabled') || !b:wheel_enabled
    let b:wheel_enabled = 1
  else
    let b:wheel_enabled = 0
  endif

  if b:wheel_enabled
    nmap <silent><buffer> j <Plug>(WheelDown)
    vmap <silent><buffer> j <Plug>(WheelDown)
    nmap <silent><buffer> k <Plug>(WheelUp)
    vmap <silent><buffer> k <Plug>(WheelUp)
    nmap <silent><buffer> h <Plug>(WheelLeft)
    vmap <silent><buffer> h <Plug>(WheelLeft)
    nmap <silent><buffer> l <Plug>(WheelRight)
    vmap <silent><buffer> l <Plug>(WheelRight)
    echo "Wheel mode enabled"
  else
    nunmap <buffer> j
    vunmap <buffer> j
    nunmap <buffer> k
    vunmap <buffer> k
    nunmap <buffer> h
    vunmap <buffer> h
    nunmap <buffer> l
    vunmap <buffer> l
    echo "Wheel mode disabled"
  endif
endfunction

nnoremap <Leader>P <Cmd>call <SID>ToggleWheel()<CR>
vnoremap <Leader>P <Cmd>call <SID>ToggleWheel()<CR>
