packadd! neotest
packadd! neotest-elixir

function! s:NeotestSetup() abort
lua <<EOF
  require'neotest'.setup({
    adapters = {
      require('neotest-elixir'),
    }
  })
EOF
endfunction

call bfc#plugins#on_load(funcref('<SID>NeotestSetup'))
