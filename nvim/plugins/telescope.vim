packadd! telescope
packadd! telescope-fzy-native
packadd! nvim-neoclip

function! s:TelescopeSetup() abort
lua <<EOF
  local actions = require'telescope.actions'
  local action_layout = require'telescope.actions.layout'
  local action_state = require'telescope.actions.state'
  local utils = require'telescope.utils'
  require'telescope'.setup {
    defaults = {
      mappings = {
        n = {
          ['<Leader>p'] = action_layout.toggle_preview
        },
        i = {
          ['<Leader>p'] = action_layout.toggle_preview,
        },
      },
      vimgrep_arguments = {
        'rg',
        '--color=never',
        '--no-heading',
        '--with-filename',
        '--line-number',
        '--column',
        '--smart-case',
        '--trim'
      },
    },
    pickers = {
      find_files = {
        find_command = { 'fd', '--type', 'f', '--strip-cwd-prefix' }
      },
      file_browser = {
        theme = 'ivy'
      }
    },
  }
  require'neoclip'.setup()

  require'telescope'.load_extension 'fzy_native'
  require'telescope'.load_extension 'neoclip'
EOF
endfunction

call bfc#plugins#on_load(funcref('<SID>TelescopeSetup'))

nnoremap <Leader>ff <Cmd>Telescope find_files<cr>
nnoremap <Leader>fF <Cmd>Telescope file_browser<cr>
nnoremap <Leader>fg <Cmd>Telescope live_grep<cr>
nnoremap <Leader>fG <Cmd>Telescope grep_string<cr>
nnoremap <Leader>fb <Cmd>Telescope buffers<cr>
nnoremap <Leader>fh <Cmd>Telescope help_tags<cr>

nnoremap <Leader>fp <Cmd>Telescope neoclip<cr>
nnoremap <Leader>fP <Cmd>Telescope neoclip star<cr>
