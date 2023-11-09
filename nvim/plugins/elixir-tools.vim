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
