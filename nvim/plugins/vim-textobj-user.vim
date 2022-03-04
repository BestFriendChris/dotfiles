packadd! vim-textobj-user

let s:sfile = expand('<sfile>')

function! s:TextObjUserSetup() abort
  "------------------------------------------------------------------------------------------------------------------------
  " From textobj-user-introduction
  "------------------------------------------------------------------------------------------------------------------------

  " {{{ date (ad, id), time - (at, it)
  call textobj#user#plugin('datetime', {
  \   'date': {
  \     'pattern': '\<\d\d\d\d-\d\d-\d\d\>',
  \     'select': ['ad', 'id'],
  \   },
  \   'time': {
  \     'pattern': '\<\d\d:\d\d:\d\d\>',
  \     'select': ['at', 'it'],
  \   },
  \ })
  " }}}

  " {{{ line - (al, il)
  call textobj#user#plugin('line', {
  \   '-': {
  \     'sfile': s:sfile,
  \     'select-a-function': 's:currentLineA',
  \     'select-a': 'al',
  \     'select-i-function': 's:currentLineI',
  \     'select-i': 'il',
  \   },
  \ })

  function! s:currentLineA() " {{{
    normal! 0
    let head_pos = getpos('.')
    normal! $
    let tail_pos = getpos('.')
    return ['v', head_pos, tail_pos]
  endfunction " }}}

  function! s:currentLineI() " {{{
    normal! ^
    let head_pos = getpos('.')
    normal! g_
    let tail_pos = getpos('.')
    let non_blank_char_exists_p = getline('.')[head_pos[2] - 1] !~# '\s'
    return
    \ non_blank_char_exists_p
    \ ? ['v', head_pos, tail_pos]
    \ : 0
  endfunction " }}}
  " }}}

  "------------------------------------------------------------------------------------------------------------------------
  " From https://web.archive.org/web/20201108142554/https://vimways.org/2018/transactions-pending/
  "------------------------------------------------------------------------------------------------------------------------

  " {{{ number (an, in)
  call textobj#user#plugin('number', {
  \   '-': {
  \     'sfile': s:sfile,
  \     'select-a-function': 's:aroundNumber',
  \     'select-a': 'an',
  \     'select-i-function': 's:inNumber',
  \     'select-i': 'in',
  \   },
  \ })

  " regular expressions that match numbers (order matters .. keep '\d' last!)
  " note: \+ will be appended to the end of each
  let s:regNums = [ '0b[01]', '0x\x', '\d' ]

  function! s:inNumber() "{{{
  " select the next number on the line
  " this can handle the following three formats (so long as s:regNums is
  " defined as it should be above this function):
  "   1. binary  (eg: "0b1010", "0b0000", etc)
  "   2. hex     (eg: "0xffff", "0x0000", "0x10af", etc)
  "   3. decimal (eg: "0", "0000", "10", "01", etc)
  " NOTE: if there is no number on the rest of the line starting at the
  "       current cursor position, then visual selection mode is ended (if
  "       called via an omap) or nothing is selected (if called via xmap)

  " need magic for this to work properly
  let l:magic = &magic
  set magic

  let l:lineNr = line('.')

  " create regex pattern matching any binary, hex, decimal number
  let l:pat = join(s:regNums, '\+\|') . '\+'

  " move cursor to end of number
  if (!search(l:pat, 'ce', l:lineNr))
  " if it fails, there was not match on the line, so return prematurely
  return 0
  endif
    let tail_pos = getpos('.')

  " move cursor to beginning of number
  call search(l:pat, 'cb', l:lineNr)

    let head_pos = getpos('.')

  " restore magic
  let &magic = l:magic

  return ['v', head_pos, tail_pos]
  endfunction "}}}

  function! s:aroundNumber() " {{{
  " select the next number on the line and any surrounding white-space;
  " this can handle the following three formats (so long as s:regNums is
  " defined as it should be above these functions):
  "   1. binary  (eg: "0b1010", "0b0000", etc)
  "   2. hex     (eg: "0xffff", "0x0000", "0x10af", etc)
  "   3. decimal (eg: "0", "0000", "10", "01", etc)
  " NOTE: if there is no number on the rest of the line starting at the
  "       current cursor position, then visual selection mode is ended (if
  "       called via an omap) or nothing is selected (if called via xmap);
  "       this is true even if on the space following a number

  " need magic for this to work properly
  let l:magic = &magic
  set magic

  let l:lineNr = line('.')

  " create regex pattern matching any binary, hex, decimal number
  let l:pat = join(s:regNums, '\+\|') . '\+'

  " move cursor to end of number
  if (!search(l:pat, 'ce', l:lineNr))
  " if it fails, there was not match on the line, so return prematurely
  return 0
  endif

  " move cursor to end of any trailing white-space (if there is any)
  call search('\%'.(virtcol('.')).'v.\s*', 'ce', l:lineNr)

    let tail_pos = getpos('.')

  " move cursor to beginning of number
  call search(l:pat, 'cb', l:lineNr)

  " move cursor to beginning of any white-space preceding number (if any)
  call search('\s*\%'.virtcol('.').'v', 'b', l:lineNr)

    let head_pos = getpos('.')

  " restore magic
  let &magic = l:magic

  return ['v', head_pos, tail_pos]
  endfunction "}}}
  " }}}

  " {{{ indentation (ai, ii)
  call textobj#user#plugin('indentation', {
  \   '-': {
  \     'sfile': s:sfile,
  \     'select-a-function': 's:aroundIndentation',
  \     'select-a': 'ai',
  \     'select-i-function': 's:inIndentation',
  \     'select-i': 'ii',
  \   },
  \ })

  function! s:inIndentation() " {{{
  " select all text in current indentation level excluding any empty lines
  " that precede or follow the current indentationt level;
  "
  " the current implementation is pretty fast, even for many lines since it
  " uses "search()" with "\%v" to find the unindented levels
  "
  " NOTE: if the current level of indentation is 1 (ie in virtual column 1),
  "       then the entire buffer will be selected
  "
  " WARNING: python devs have been known to become addicted to this

  " magic is needed for this
  let l:magic = &magic
  set magic

  " move to beginning of line and get virtcol (current indentation level)
  " BRAM: there is no searchpairvirtpos() ;)
  normal! ^
  let l:vCol = virtcol(getline('.') =~# '^\s*$' ? '$' : '.')

  " pattern matching anything except empty lines and lines with recorded
  " indentation level
  let l:pat = '^\(\s*\%'.l:vCol.'v\|^$\)\@!'

  " find first match (backwards & don't wrap or move cursor)
  let l:start = search(l:pat, 'bWn') + 1

  " next, find first match (forwards & don't wrap or move cursor)
  let l:end = search(l:pat, 'Wn')

  if (l:end !=# 0)
  " if search succeeded, it went too far, so subtract 1
  let l:end -= 1
  endif

  " go to start (this includes empty lines) and--importantly--column 0
  execute 'normal! '.l:start.'G0'

  " skip empty lines (unless already on one .. need to be in column 0)
  call search('^[^\n\r]', 'Wc')

    let head_pos = getpos('.')

  " go to end (this includes empty lines)
  execute 'normal! '.l:end.'G'

  " skip backwards to last selected non-empty line
  call search('^[^\n\r]', 'bWc')

    let tail_pos = getpos('.')

  " restore magic
  let &magic = l:magic

    return ['V', head_pos, tail_pos]
  endfunction " }}}

  function! s:aroundIndentation() " {{{
  " select all text in the current indentation level including any emtpy
  " lines that precede or follow the current indentation level;
  "
  " the current implementation is pretty fast, even for many lines since it
  " uses "search()" with "\%v" to find the unindented levels
  "
  " NOTE: if the current level of indentation is 1 (ie in virtual column 1),
  "       then the entire buffer will be selected
  "
  " WARNING: python devs have been known to become addicted to this

  " magic is needed for this (/\v doesn't seem work)
  let l:magic = &magic
  set magic

  " move to beginning of line and get virtcol (current indentation level)
  " BRAM: there is no searchpairvirtpos() ;)
  normal! ^
  let l:vCol = virtcol(getline('.') =~# '^\s*$' ? '$' : '.')

  " pattern matching anything except empty lines and lines with recorded
  " indentation level
  let l:pat = '^\(\s*\%'.l:vCol.'v\|^$\)\@!'

  " find first match (backwards & don't wrap or move cursor)
  let l:start = search(l:pat, 'bWn') + 1
  execute 'normal! '.l:start.'G0'
    let head_pos = getpos('.')

  " NOTE: if l:start is 0, then search() failed; otherwise search() succeeded
  "       and l:start does not equal line('.')
  " FORMER: l:start is 0; so, if we add 1 to l:start, then it will match
  "         everything from beginning of the buffer (if you don't like
  "         this, then you can modify the code) since this will be the
  "         equivalent of "norm! 1G" below
  " LATTER: l:start is not 0 but is also not equal to line('.'); therefore,
  "         we want to add one to l:start since it will always match one
  "         line too high if search() succeeds

  " next, find first match (forwards & don't wrap or move cursor)
  let l:end = search(l:pat, 'Wn')

  " NOTE: if l:end is 0, then search() failed; otherwise, if l:end is not
  "       equal to line('.'), then the search succeeded.
  " FORMER: l:end is 0; we want this to match until the end-of-buffer if it
  "         fails to find a match for same reason as mentioned above;
  "         again, modify code if you do not like this); therefore, keep
  "         0--see "NOTE:" below inside the if block comment
  " LATTER: l:end is not 0, so the search() must have succeeded, which means
  "         that l:end will match a different line than line('.')

  if (l:end !=# 0)
  " if l:end is 0, then the search() failed; if we subtract 1, then it
  " will effectively do "norm! -1G" which is definitely not what is
  " desired for probably every circumstance; therefore, only subtract one
  " if the search() succeeded since this means that it will match at least
  " one line too far down
  " NOTE: exec "norm! 0G" still goes to end-of-buffer just like "norm! G",
  "       so it's ok if l:end is kept as 0. As mentioned above, this means
  "       that it will match until end of buffer, but that is what I want
  "       anyway (change code if you don't want)
  let l:end -= 1
  endif

  execute 'normal! '.l:end.'G$'
    let tail_pos = getpos('.')

  " restore magic
  let &magic = l:magic

    return ['V', head_pos, tail_pos]
  endfunction " }}}
  " }}}
endfunction

call bfc#plugins#on_load(funcref('<SID>TextObjUserSetup'))

" vim:foldmethod=marker foldmarker={{{,}}} foldlevel=0
