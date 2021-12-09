source ~/.config/nvim/plugins/dracula.vim
augroup ColorSchemeSelect
  autocmd!
  autocmd User PackagesLoaded ++nested
    \ colorscheme dracula
augroup end


