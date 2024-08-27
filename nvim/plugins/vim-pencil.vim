packadd! vim-pencil

let g:pencil#conceallevel=0
let g:pencil#wrapModeDefault = 'soft'

augroup bfcPencil
  autocmd!
  autocmd FileType markdown,mkd call pencil#init()
  autocmd FileType text         call pencil#init({'wrap': 'hard'})
augroup END
