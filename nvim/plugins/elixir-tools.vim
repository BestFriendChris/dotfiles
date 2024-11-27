packadd! elixir-tools

function! s:ElixirToolsSetup() abort
  lua <<EOF
  local elixir = require('elixir')
  local elixirls = require('elixir.elixirls')

  elixir.setup {
    nextls = {
      enable = false,
    },
    elixirls = {
      enable = true,
      tag = "v0.24.1",
      settings = elixirls.settings {
        dialyzerEnabled = false,
        enableTestLenses = false,
      },
    }
  }
EOF
endfunction

call bfc#plugins#on_load(funcref('<SID>ElixirToolsSetup'))

function! s:CommonMappings() abort
  nnoremap <buffer> <silent> \\ <Cmd>:A<CR>

  compiler exunit
  nnoremap <buffer> <silent> 'f <Cmd>Focus mix test --failed<CR>:Dispatch<CR>

endfunction

function! s:ElixirMappings() abort
  call s:CommonMappings()
endfunction

function! s:ElixirTestMappings() abort
  call s:CommonMappings()

  let b:dispatch = "mix test %"

  nnoremap <buffer> <silent> <expr> '. ':Focus mix test '.join([expand("%"), line(".")], ":").'<CR>:Dispatch<CR>'
  nnoremap <buffer> <silent> <expr> '% ':Focus mix test '.expand("%:h").'<CR>:Dispatch<CR>'

endfunction

augroup bfcElixir
  autocmd!
  autocmd BufNewFile,BufReadPost *.ex call s:ElixirMappings()
  autocmd BufNewFile,BufReadPost *_test.exs call s:ElixirTestMappings()
augroup end
