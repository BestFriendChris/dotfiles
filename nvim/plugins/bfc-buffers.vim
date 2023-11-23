function! s:BufClear()
  let l:closed = 0
  for buf in getbufinfo()
    if buf.hidden != 0
      silent! execute 'bdelete ' buf.bufnr
      let l:closed += 1
    endif
  endfor
  echo "Closed " . l:closed . " hidden buffers"
endfunction

command! BufClear call s:BufClear()
