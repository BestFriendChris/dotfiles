" ============================================================================
" File:        bubblepipe.vim
" Description: autoload functions for bubble-pipe plugin
" Maintainer:  BestFriendChris <https://github.com/BestFriendChris>
" Created:     March 04, 2022
" License:     The MIT License (MIT)
" ============================================================================

function! s:CopyToTempFile(temp_file)
  let l:save_modified=&modified
  silent execute 'write! '.a:temp_file
  let &modified=l:save_modified
endfunction

function! s:LoadCmd()
  let l:first_line = getline(1)
  if matchstrpos(l:first_line, '^.*BUBBLEPIPE:')[1] == 0
    " if the first line contains 'BUBBLEPIPE:', save the remainder of the line
    let b:bubblepipe__cmd = substitute(l:first_line, '^.*BUBBLEPIPE:', '', '')
  else
    if exists("b:bubblepipe__cmd")
      unlet b:bubblepipe__cmd
    endif
  endif
endfunction

function! s:EnsureOutputWindowOpen()
  if !exists("b:bubblepipe__output__window_name")
    let b:bubblepipe__output__window_name="Pipe Output - ".expand("%")
  endif

  if !bufexists(b:bubblepipe__output__window_name)
    let l:input__buffer_nr = bufnr("%")
    new
    let b:bubblepipe__output__window_name=getbufvar(l:input__buffer_nr, "bubblepipe__output__window_name")
    let b:bubblepipe__input__winid=getbufvar(l:input__buffer_nr, "bubblepipe__input__winid")
    let b:bubblepipe__mapping=getbufvar(l:input__buffer_nr, "bubblepipe__mapping")
    let b:bubblepipe__input__buffer_nr=l:input__buffer_nr
    let b:bubblepipe__is_output=1
    let b:bubblepipe__init = 1
    call setbufvar(l:input__buffer_nr, 'bubblepipe__output__window_nr', win_getid(winnr()))

    setlocal buftype=nofile bufhidden=hide noswapfile
    silent execute "file ".b:bubblepipe__output__window_name
    call s:SetupMappings()
    call win_gotoid(b:bubblepipe__input__winid)
  endif
endfunction

function! s:EnsureOnInputFile()
  if exists('b:bubblepipe__is_output')
    call win_gotoid(b:bubblepipe__input__winid)
  endif
endfunction

function! s:EnsureOnOutputScratch()
  if !bufexists(b:bubblepipe__output__window_name)
    call EnsureOutputWindowOpen()
  endif
  if exists('b:bubblepipe__output__window_nr')
    call win_gotoid(b:bubblepipe__output__window_nr)
  endif
endfunction

function! s:RunFromFile(temp_file)
  call s:EnsureOnOutputScratch()
  let l:winview = winsaveview()
  let l:cmd = getbufvar(b:bubblepipe__input__buffer_nr, 'bubblepipe__cmd')

  echo "Refreshing..."
  silent execute "%d | call append(0, 'Piped at '.strftime('%Y-%m-%d %T'))"
  silent execute "call append(1, '--------------------------------------------------------------------------------')"
  silent execute "$read ! cat ".a:temp_file." | ".l:cmd

  call winrestview(l:winview)
endfunction

function! s:SetupMappings()
  silent execute "map <buffer><silent> ".b:bubblepipe__mapping." <Cmd>call bubblepipe#run()<CR>"
endfunction

function! bubblepipe#run()
  if !exists('b:bubblepipe__init')
    let b:bubblepipe__temp_file=tempname()
    let b:bubblepipe__input__winid=win_getid(winnr())
    let b:bubblepipe__init = 1
  endif

  let l:current_nr = win_getid(winnr())
  let l:winview = winsaveview()

  call s:EnsureOnInputFile()

  call s:LoadCmd()

  if !exists("b:bubblepipe__cmd")
    if !exists("b:bubblepipe__helped")
      let l:comment_prefix = substitute(&commentstring, '%s.*$', ' ', '')
      let l:comment_postfix = substitute(&commentstring, '^.*%s', ' ', '')
      let l:comment_postfix_for_command = l:comment_postfix == ' ' ? '' : ' #' . l:comment_postfix
      let l:example_command =
            \ &filetype == 'sql'
            \   ? 'psql -d database'
            \   : 'wc'
      call append(0, l:comment_prefix . " To use BubblePipe, add the command to pipe your into as the first line:" . l:comment_postfix)
      call append(1, l:comment_prefix . "BUBBLEPIPE: " . l:example_command . l:comment_postfix_for_command)
      let b:bubblepipe__helped = 1
    else
      echo "Add BUBBLEPIPE command to first line to use"
    endif
  else
    if exists("b:bubblepipe__helped")
      unlet b:bubblepipe__helped
    endif

    call s:EnsureOutputWindowOpen()
    call s:CopyToTempFile(b:bubblepipe__temp_file)
    call s:RunFromFile(b:bubblepipe__temp_file)
  endif

  call win_gotoid(l:current_nr)
  call winrestview(l:winview)
endfunction

function! bubblepipe#map(mapping)
  let b:bubblepipe__mapping = a:mapping
  call s:SetupMappings()
endfunction
