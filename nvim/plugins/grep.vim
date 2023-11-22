if executable("rg")
  set grepprg=rg\ --vimgrep\ --engine=auto
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif
