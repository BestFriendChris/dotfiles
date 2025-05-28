packadd! rustaceanvim

function! s:RustMappings() abort
  nnoremap <buffer> <silent> <localleader>, <Cmd>RustLsp hover actions<CR>
  nnoremap <buffer> <silent> <localleader>? <Cmd>RustLsp explainError<CR>
  nnoremap <buffer> <silent> <localleader>. <Cmd>RustLsp renderDiagnostic<CR>
endfunction

augroup bfcRustaceanvim
  autocmd!
  autocmd BufNewFile,BufReadPost *.rs call s:RustMappings()
augroup end
