if executable("rg")
  set grepprg=rg\ --vimgrep\ --smart-case\ --engine=auto
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif
