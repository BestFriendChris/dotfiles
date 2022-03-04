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
    nmap <silent> j <Plug>(WheelDown)
    vmap <silent> j <Plug>(WheelDown)
    nmap <silent> k <Plug>(WheelUp)
    vmap <silent> k <Plug>(WheelUp)
    nmap <silent> h <Plug>(WheelLeft)
    vmap <silent> h <Plug>(WheelLeft)
    nmap <silent> l <Plug>(WheelRight)
    vmap <silent> l <Plug>(WheelRight)
    echo "Wheel mode enabled"
  else
    nunmap j
    vunmap j
    nunmap k
    vunmap k
    nunmap h
    vunmap h
    nunmap l
    vunmap l
    echo "Wheel mode disabled"
  endif
endfunction

nnoremap <Leader>P <Cmd>call <SID>ToggleWheel()<CR>
vnoremap <Leader>P <Cmd>call <SID>ToggleWheel()<CR>
