if exists('g:started_by_firenvim')
  packadd! firenvim
endif

function! s:InstallFirenvim() abort
  packadd firenvim
  call firenvim#install(0)
endfunction
call bfc#install#register("InstallFirenvim", funcref('<SID>InstallFirenvim'))
