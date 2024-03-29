if polyglot#init#is_disabled(expand('<sfile>:p'), 'elixir', 'compiler/exunit.vim')
  finish
endif

if exists("current_compiler")
  finish
endif
let current_compiler = "exunit"

if exists(":CompilerSet") != 2    " older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C
CompilerSet makeprg=mix\ test
CompilerSet errorformat=
  \%E\ \ %n)\ %m,
  \%+G\ \ \ \ \ **\ %m,
  \%C\ \ \ \ \ %f:%l,
  \%+G\ \ \ \ \ \ \ (%*[^)])\ %f:%l:\ %m,
  \%+G\ \ \ \ \ \ \ %f:%l:\ %.%#,
  \**\ (%*[^)])\ %f:%l:\ %m

let &cpo = s:cpo_save
unlet s:cpo_save

" vim: nowrap sw=2 sts=2 ts=8:
