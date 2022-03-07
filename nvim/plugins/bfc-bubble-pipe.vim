packadd! bfc-bubble-pipe

augroup bfc_bubblepipe
  autocmd!

  autocmd FileType sql
        \ call bubblepipe#map('<LocalLeader>r')
augroup END
