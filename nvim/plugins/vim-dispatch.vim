packadd! vim-dispatch

let g:dispatch_no_maps = 1

nnoremap <silent> m<CR> <Cmd>Make<CR>
nnoremap <silent> m<Space> :Make<Space>
nnoremap <silent> m! <Cmd>Make!<CR>
nnoremap <silent> m? <Cmd>echo ":Dispatch" dispatch#make_focus(v:count > 1 ? 0 : v:count ? line(".") : -1)<CR>

nnoremap <silent> '' <Cmd>Dispatch<CR>
nnoremap <silent> '<CR> <Cmd>FocusDispatch!<CR>:Dispatch<CR>
nnoremap <silent> '<Space> :Dispatch<Space>
nnoremap <silent> '! <Cmd>Dispatch!<CR>
nnoremap <silent> '? <Cmd>FocusDispatch<CR>

