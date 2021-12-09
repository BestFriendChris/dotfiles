packadd! dracula

augroup DraculaOverrides
  autocmd!
  autocmd ColorScheme dracula highlight Normal guibg=none ctermbg=none
  autocmd ColorScheme dracula highlight DraculaBoundary guibg=none
  autocmd ColorScheme dracula highlight DraculaDiffDelete ctermbg=none guibg=none
  autocmd ColorScheme dracula highlight DraculaComment cterm=italic gui=italic
augroup end


