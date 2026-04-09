packadd! render-markdown

lua <<EOF
require('render-markdown').setup({
    -- Whether markdown should be rendered by default.
    enabled = true,
    -- Vim modes that will show a rendered view of the markdown file, :h mode(), for all enabled
    -- components. Individual components can be enabled for other modes. Remaining modes will be
    -- unaffected by this plugin.
    render_modes = { 'n', 'c', 't' },
    -- Filetypes this plugin will run on.
    file_types = { 'markdown' },
    heading = {
      position = "inline",
      width = "block",
      right_pad = 1,
      border = true,
      below = '▔',
      above = '▁',

    },
    code = {
      border = 'thick',
      position = 'right',
      language_icon = false,
      width = 'block',
      right_pad = 10,
    },
    latex = {
        enabled = false,
    },
    html = {
        comment = {
            conceal = false,
        },
    },
})
EOF
