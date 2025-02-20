packadd! telescope
packadd! telescope-fzy-native
packadd! telescope-file-browser
packadd! nvim-neoclip

function! s:TelescopeSetup() abort
lua <<EOF
  local builtin = require'telescope.builtin'
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
    },
  }
  require("telescope").setup {
    extensions = {
      file_browser = {
        theme = "ivy",
        -- disables netrw and use telescope-file-browser in its place
        hijack_netrw = true,
      },
    },
  }
  require'neoclip'.setup()

  require'telescope'.load_extension 'fzy_native'
  require'telescope'.load_extension 'neoclip'

  vim.keymap.set('n', '<Leader>f.f', function() builtin.find_files({ cwd = utils.buffer_dir() }) end, {
    desc = 'Telescope find_files (cwd = buffer_dir)'
  })
  vim.keymap.set('n', '<Leader>f.g', function() builtin.live_grep({ cwd = utils.buffer_dir() }) end, {
    desc = 'Telescope live_grep (cwd = buffer_dir)'
  })
  vim.keymap.set('n', '<Leader>f.G', function() builtin.grep_string({ cwd = utils.buffer_dir() }) end, {
    desc = 'Telescope grep_string (cwd = buffer_dir)'
  })
EOF
endfunction

call bfc#plugins#on_load(funcref('<SID>TelescopeSetup'))

nnoremap <Leader>ff <Cmd>Telescope find_files<cr>
nnoremap <Leader>fg <Cmd>Telescope live_grep<cr>
nnoremap <Leader>fG <Cmd>Telescope grep_string<cr>
nnoremap <Leader>fb <Cmd>Telescope buffers<cr>
nnoremap <Leader>fh <Cmd>Telescope help_tags<cr>

nnoremap <Leader>fp <Cmd>Telescope neoclip<cr>
nnoremap <Leader>fP <Cmd>Telescope neoclip star<cr>

nnoremap <Leader>fld <Cmd>Telescope lsp_document_symbols<cr>
nnoremap <Leader>flr <Cmd>Telescope lsp_references<cr>
