packadd! vim-tasks

let g:TasksArchiveSeparator="--------------------------------------------------------------------------------"

function! s:TasksSetup()
  imap <buffer> <Tab> <C-o>:normal >><CR><Right><Right>
  imap <buffer> <S-Tab> <Left><Left><C-o>:normal <<<CR>
  imap <buffer> <C-Enter> <ESC>,n
  imap <buffer> <C-S-Enter> <ESC>,N
endfunction

augroup bfcTasks
  autocmd!
  autocmd ColorScheme * highlight link tMarker Tag
  autocmd ColorScheme * highlight link tMarkerInProgress CursorLineNr
  autocmd ColorScheme * highlight link tMarkerComplete Function
  autocmd ColorScheme * highlight link tLowPriority Tag
  autocmd ColorScheme * highlight link tMediumPriority CursorLineNr
  autocmd ColorScheme * highlight link tHighPriority PreProc
  autocmd ColorScheme * highlight link tCriticalPriority IncSearch
  autocmd ColorScheme * highlight link tAttribute Type
  autocmd FileType tasks call s:TasksSetup()
augroup end

