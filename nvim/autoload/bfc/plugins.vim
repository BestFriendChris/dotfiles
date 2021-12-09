function! bfc#plugins#load(plugin)
  let plugin_file = expand('~/.config/nvim/plugins/' . a:plugin . '.vim')
  if filereadable(plugin_file)
    execute 'source ' . plugin_file
  else
    execute 'packadd! ' . a:plugin
  endif
endfunction

function! bfc#plugins#colorscheme(cs_name)
  " Set colorscheme once all packages are loaded
  augroup ColorSchemeSelect
    autocmd!
    execute 'autocmd User PackagesLoaded ++nested colorscheme ' . a:cs_name
  augroup end
endfunction

