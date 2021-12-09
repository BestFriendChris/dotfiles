function! bfc#plugins#load(plugin)
  execute 'source ~/.config/nvim/plugins/' . a:plugin . '.vim'
endfunction

function! bfc#plugins#colorscheme(cs_name)
  " Set colorscheme once all packages are loaded
  augroup ColorSchemeSelect
    autocmd!
    execute 'autocmd User PackagesLoaded ++nested colorscheme ' . a:cs_name
  augroup end
endfunction

