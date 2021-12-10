" Allow registering functions to run when the vim plugins have been updated

let g:bfc_post_install_scripts = {}

function! bfc#install#register(name, func_ref)
  let g:bfc_post_install_scripts[a:name] = a:func_ref
endfunction

function! bfc#install#run()
  for name in keys(g:bfc_post_install_scripts)
    echom "Running ".name
    call g:bfc_post_install_scripts[name]()
  endfor
endfunction
