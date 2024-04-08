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
      tag = "v0.20.0",
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

  " Neotest
  nnoremap <buffer> <silent> <LocalLeader>r<Space> <Cmd>lua require("neotest").summary.toggle()<CR>
  nnoremap <buffer> <silent> <LocalLeader>rr <Cmd>lua require("neotest").run.run_last()<CR>
  nnoremap <buffer> <silent> <LocalLeader>ra <Cmd>lua require("neotest").run.run("test")<CR>
endfunction

function! s:ElixirMappings() abort
  call s:CommonMappings()
endfunction

function! s:ElixirTestMappings() abort
  call s:CommonMappings()

  let b:dispatch = "mix test %"

  nnoremap <buffer> <silent> <expr> '. ':Focus mix test '.join([expand("%"), line(".")], ":").'<CR>:Dispatch<CR>'

  " Neotest
  nnoremap <buffer> <silent> <LocalLeader>rt <Cmd>lua require("neotest").run.run(vim.fn.expand("%"))<CR>
  nnoremap <buffer> <silent> <LocalLeader>r. <Cmd>lua require("neotest").run.run()<CR>
  nnoremap <buffer> <silent> <LocalLeader>rK <Cmd>lua require("neotest").output.open({ enter = true})<CR>

  nnoremap <buffer> <silent> <LocalLeader>rp <Cmd>lua require("neotest").jump.prev({ status = "failed" })<CR>
  nnoremap <buffer> <silent> <LocalLeader>rn <Cmd>lua require("neotest").jump.next({ status = "failed" })<CR>
endfunction

function! s:ElixirNeotestSummary() abort
  nnoremap <buffer> <silent> <LocalLeader>r<Space> <Cmd>lua require("neotest").summary.close()<CR>
endfunction

augroup bfcElixirNeotest
  autocmd!
  autocmd BufNewFile,BufReadPost *.ex call s:ElixirMappings()
  autocmd BufNewFile,BufReadPost *_test.exs call s:ElixirTestMappings()
  autocmd FileType neotest-summary call s:ElixirNeotestSummary()
augroup end
