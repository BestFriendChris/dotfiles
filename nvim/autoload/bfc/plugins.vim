function! bfc#plugins#load(plugin) abort
  let plugin_file = expand('~/.config/nvim/plugins/' . a:plugin . '.vim')
  if filereadable(plugin_file)
    execute 'source ' . plugin_file
  else
    execute 'packadd! ' . a:plugin
  endif
endfunction

let g:bfc_plugin_load = []
function! bfc#plugins#on_load(func_ref) abort
  call add(g:bfc_plugin_load, a:func_ref)
endfunction

function! bfc#plugins#colorscheme(cs_name) abort
  " Load colorscheme after all plugins loaded
  augroup ColorSchemeSelect
    autocmd!
    execute 'autocmd User PackagesLoaded ++nested colorscheme ' . a:cs_name
  augroup end
endfunction

function! bfc#plugins#packages_loaded() abort
  for FuncRef in g:bfc_plugin_load
    call FuncRef()
  endfor
  doautocmd User PackagesLoaded
endfunction
