packadd! vim-tasks

let g:TasksArchiveSeparator="--------------------------------------------------------------------------------"

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
augroup end
