function! bfc#plugins#load(plugin) abort
  let plugin_file = expand('~/.config/nvim/plugins/' . a:plugin . '.vim')
  if filereadable(plugin_file)
    execute 'source ' . plugin_file
  else
    execute 'packadd! ' . a:plugin
  endif
endfunction

let g:bfc_plugin_load = {}
function! bfc#plugins#on_load(group_name, func_ref) abort
  let g:bfc_plugin_load[a:group_name] = a:func_ref
  execute 'augroup ' . a:group_name
  execute '  autocmd!'
  execute "  autocmd User PackagesLoaded ++nested call g:bfc_plugin_load['" . a:group_name . "']()"
  execute 'augroup end'
endfunction

function! bfc#plugins#colorscheme(cs_name) abort
  " Set colorscheme once all packages are loaded
  augroup ColorSchemeSelect
    autocmd!
    execute 'autocmd User PackagesLoaded ++nested colorscheme ' . a:cs_name
  augroup end
endfunction

