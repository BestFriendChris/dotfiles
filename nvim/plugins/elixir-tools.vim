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
      settings = elixirls.settings {
        dialyzerEnabled = false,
        enableTestLenses = true,
      },
    }
  }
EOF
endfunction

call bfc#plugins#on_load(funcref('<SID>ElixirToolsSetup'))

function! s:ElixirNeotestMappings() abort
  nnoremap <buffer> <silent> <LocalLeader>rf <Cmd>lua require("neotest").run.run(vim.fn.expand("%"))<CR>
  nnoremap <buffer> <silent> <LocalLeader>r. <Cmd>lua require("neotest").run.run()<CR>
  nnoremap <buffer> <silent> <LocalLeader>rr <Cmd>lua require("neotest").run.run_last()<CR>
  nnoremap <buffer> <silent> <LocalLeader>ra <Cmd>lua require("neotest").run.run("test")<CR>

  nnoremap <buffer> <silent> <LocalLeader>r<Space> <Cmd>lua require("neotest").summary.toggle()<CR>

  nnoremap <buffer> <silent> <LocalLeader>rp <Cmd>lua require("neotest").jump.prev({ status = "failed" })<CR>
  nnoremap <buffer> <silent> <LocalLeader>rn <Cmd>lua require("neotest").jump.next({ status = "failed" })<CR>
endfunction

augroup bfcElixirNeotest
  autocmd!
  autocmd BufNewFile,BufReadPost *_test.exs call s:ElixirNeotestMappings()
augroup end
