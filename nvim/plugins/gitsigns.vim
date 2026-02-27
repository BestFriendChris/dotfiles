packadd! gitsigns

lua << EOF
require"gitsigns".setup {
  on_attach = function(bufnr)
    local gs = require('gitsigns')

    local function map(mode, l, r, desc)
      vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
    end


    -- Navigation
    map('n', ']g', gs.next_hunk, 'Go to next hunk')
    map('n', '[g', gs.prev_hunk, 'Go to previous hunk')

    -- Actions
    map('n', '<leader>hs', gs.stage_hunk, 'Stage hunk')
    map('n', '<leader>hr', gs.reset_hunk, 'Reset hunk')

    map('v', '<leader>hs', function()
      gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end, 'Stage hunk')

    map('v', '<leader>hr', function()
      gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end, 'Reset hunk')

    map('n', '<leader>hS', gs.stage_buffer, 'Stage buffer')
    map('n', '<leader>hu', gs.undo_stage_hunk, 'Undo stage buffer')
    map('n', '<leader>hR', gs.reset_buffer, 'Reset buffer')
    map('n', '<leader>hp', gs.preview_hunk, 'Preview hunk')
    map('n', '<leader>hi', gs.preview_hunk_inline, 'Preview hunk inline')

    map('n', '<leader>hb', function()
      gs.blame_line({ full = true })
    end, 'Blame line')

    map('n', '<leader>hd', gs.diffthis, 'Diff this')

    map('n', '<leader>hD', function()
      gs.diffthis('~')
    end, 'Diff this ~')

    map('n', '<leader>hQ', function() gs.setqflist('all') end, 'Set qflist (all)')
    map('n', '<leader>hq', gs.setqflist, 'Set qflist')

    -- Toggles
    map('n', '<leader>gtb', gs.toggle_current_line_blame, 'Toggle current line blame')
    map('n', '<leader>gtw', gs.toggle_word_diff, 'Toggle word diff')

    -- Text object
    map({'o', 'x'}, 'ih', gs.select_hunk, 'GitSigns Select inner hunk')
  end
}
EOF

