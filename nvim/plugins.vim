call bfc#plugins#load('dracula')
call bfc#plugins#colorscheme('dracula')

" Disabling treesitter due to ftdetect bug
" call bfc#plugins#load('nvim-treesitter')

call bfc#plugins#load('plenary')

call bfc#plugins#load('firenvim')
call bfc#plugins#load('lightspeed')
call bfc#plugins#load('quick-scope')
call bfc#plugins#load('splitjoin')
call bfc#plugins#load('telescope')
call bfc#plugins#load('vim-commentary')
call bfc#plugins#load('vim-context-commentstring')
call bfc#plugins#load('vim-eunuch')
call bfc#plugins#load('vim-exchange')
call bfc#plugins#load('vim-floaterm')
call bfc#plugins#load('vim-fugitive')
call bfc#plugins#load('vim-go')
call bfc#plugins#load('vim-highlighter')
call bfc#plugins#load('vim-lion')
call bfc#plugins#load('vim-obsession')
call bfc#plugins#load('vim-peekaboo')
call bfc#plugins#load('vim-polyglot')
call bfc#plugins#load('vim-repeat')
call bfc#plugins#load('vim-scriptease')
call bfc#plugins#load('vim-speeddating')
call bfc#plugins#load('vim-surround')
call bfc#plugins#load('vim-textobj-user')
call bfc#plugins#load('vim-unimpaired')
call bfc#plugins#load('vim-wheel')
call bfc#plugins#load('zig.vim')

function! s:Helptags() abort
  helptags ALL
endfunction
call bfc#install#register("Helptags", funcref('<SID>Helptags'))
