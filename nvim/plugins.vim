call bfc#plugins#load('dracula')
call bfc#plugins#colorscheme('dracula')

call bfc#plugins#load('nvim-treesitter')

call bfc#plugins#load('plenary')

call bfc#plugins#load('vim-grepper')

call bfc#plugins#load('bfc-buffers')
call bfc#plugins#load('bfc-copy-path')
call bfc#plugins#load('bqf')
call bfc#plugins#load('conform')
call bfc#plugins#load('copilot')
call bfc#plugins#load('firenvim')
call bfc#plugins#load('fzf')
call bfc#plugins#load('gitlinker')
call bfc#plugins#load('gitsigns')
call bfc#plugins#load('lightspeed')
" call bfc#plugins#load('pqf')
call bfc#plugins#load('quick-scope')
call bfc#plugins#load('splitjoin')
call bfc#plugins#load('telescope')
call bfc#plugins#load('octo')
call bfc#plugins#load('vim-argumentative')
call bfc#plugins#load('vim-commentary')
call bfc#plugins#load('vim-context-commentstring')
call bfc#plugins#load('vim-dispatch')
call bfc#plugins#load('vim-eunuch')
call bfc#plugins#load('vim-exchange')
call bfc#plugins#load('vim-floaterm')
call bfc#plugins#load('vim-fugitive')
call bfc#plugins#load('vim-go')
call bfc#plugins#load('vim-highlighter')
call bfc#plugins#load('vim-jjdescription')
call bfc#plugins#load('vim-lion')
call bfc#plugins#load('vim-obsession')
call bfc#plugins#load('vim-peekaboo')
call bfc#plugins#load('vim-pencil')
call bfc#plugins#load('vim-polyglot')
call bfc#plugins#load('vim-projectionist')
call bfc#plugins#load('vim-repeat')
call bfc#plugins#load('vim-scriptease')
call bfc#plugins#load('vim-speeddating')
call bfc#plugins#load('vim-surround')
call bfc#plugins#load('vim-tasks')
call bfc#plugins#load('vim-textobj-user')
call bfc#plugins#load('vim-unimpaired')
call bfc#plugins#load('vim-wheel')

" Netrw replacements
call bfc#plugins#load('oil')
"call bfc#plugins#load('vim-vinegar')

" Languages
call bfc#plugins#load('nvim-lspconfig')
call bfc#plugins#load('zig')
call bfc#plugins#load('nvim-cmp-and-vsnip')
call bfc#plugins#load('elixir-tools')
call bfc#plugins#load('bfc-terraform')
call bfc#plugins#load('rustaceanvim')

call bfc#plugins#load('cfilter')
call bfc#plugins#load('grep')

function! s:Helptags() abort
  helptags ALL
endfunction
call bfc#install#register("Helptags", funcref('<SID>Helptags'))
