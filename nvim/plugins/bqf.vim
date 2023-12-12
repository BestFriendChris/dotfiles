packadd! bqf

lua << EOF
local api = vim.api
local fn = vim.fn

require('bqf').setup({
  func_map = {
    tabdrop = '<C-t>',
    tabc = '',
  }
})

-- The names of the sign types, and the symbols to insert into the quickfix
-- window.
local signs = {
  error = 'E',
  warning = 'W',
  info = 'I',
  hint = 'H',
}

local namespace = api.nvim_create_namespace('bfc_bqf')

local diagnostic_signs = {
  DiagnosticSignError = 'error',
  DiagnosticSignWarn = 'warning',
  DiagnosticSignHint = 'hint',
  DiagnosticSignInfo = 'info',
}

for diagnostic_sign, key in pairs(diagnostic_signs) do
  local sign_def = fn.sign_getdefined(diagnostic_sign)[1]

  if sign_def and sign_def.text then
    signs[key] = vim.trim(sign_def.text)
  end
end

local function apply_highlights(bufnr, highlights)
  for _, hl in ipairs(highlights) do
    vim.highlight.range(
      bufnr,
      namespace,
      hl.group,
      { hl.line, hl.col },
      { hl.line, hl.end_col }
    )
  end
end

function _G.qftf(info)
    local ret = {}
    local type_mapping = {
      E = { signs.error, 'DiagnosticError' },
      W = { signs.warning, 'DiagnosticWarn' },
      I = { signs.info, 'DiagnosticInfo' },
      N = { signs.hint, 'DiagnosticHint' },
    }


    local list
    if info.quickfix == 1 then
        list = fn.getqflist({id = info.id, items = 1, qfbufnr = 1})
    else
        list = fn.getloclist(info.winid, {id = info.id, items = 1, qfbufnr = 1})
    end
    local qf_bufnr = list.qfbufnr
    local items = list.items

    -- If we're adding a new list rather than appending to an existing one, we
    -- need to clear existing highlights.
    if info.start_idx == 1 then
      api.nvim_buf_clear_namespace(qf_bufnr, namespace, 0, -1)
    end

    local fnames = {}
    local hasQtype = false
    local hasLnum = false
    local hasCol = false
    local lnumLength = 0
    local colLength = 0
    for i = info.start_idx, info.end_idx do
      local e = items[i]
      local fname = ''
      fname = fn.bufname(e.bufnr)
      if fname ~= '' then
        fnames[fname] = true
      end
      hasQtype = hasQtype or (type_mapping[e.type] ~= nil)
      hasLnum = hasLnum or e.lnum > 0
      local lnum = e.lnum > 99999 and -1 or e.lnum
      lnumLength = math.max(lnumLength, #tostring(lnum))
      hasCol = hasCol or e.col > 0
      local col = e.col > 999 and -1 or e.col
      colLength = math.max(colLength, #tostring(col))
    end

    local fnameCount = 0
    local fnameLength = 0

    for fname, _ in pairs(fnames) do
      fnameCount = fnameCount + 1
      fnameLength = math.max(fnameLength, #fname)
    end

    local limit = math.min(31, fnameLength)
    local fnameFmt1, fnameFmt2 = '%-' .. limit .. 's', '…%.' .. (limit - 1) .. 's'

    local qtypeFmt = '%1s|'
    local fnameFmt = '%'.. limit .. 's |'
    local lnumWithColFmt = '%' .. lnumLength .. 's:%-' .. colLength .. 's|'
    local lnumFmt = '%' .. lnumLength .. 's|'
    local textFmt = '%s'

    local highlights = {}

    for i = info.start_idx, info.end_idx do
        local e = items[i]
        local line_idx = i - 1
        local fname = ''
        local str
        if e.bufnr > 0 then
            fname = fn.bufname(e.bufnr)
            if fname == '' then
                fname = '[No Name]'
            else
                fname = fname:gsub('^' .. vim.env.HOME, '~')
            end
            -- char in fname may occur more than 1 width, ignore this issue in order to keep performance
            if #fname <= limit then
                fname = fnameFmt1:format(fname)
            else
                fname = fnameFmt2:format(fname:sub(1 - limit))
            end
        end
        local lnum = e.lnum > 99999 and -1 or e.lnum
        local col = e.col > 999 and -1 or e.col
        local qtype = e.type == '' and ' ' or e.type:sub(1, 1):upper()
        local lnumStr = lnum > 0 and tostring(lnum) or ''
        local colStr = col > 0 and tostring(col) or ''

        str = ''
        local hl_start_col = 0
        if hasQtype then
          local sign, sign_hl = unpack(type_mapping[e.type] or {})
          str = str .. qtypeFmt:format(qtype)

          if sign_hl then
            table.insert(highlights, {
              group = sign_hl,
              line = line_idx,
              col = hl_start_col,
              end_col = hl_start_col + 1,
            })
          end
          hl_start_col = hl_start_col + 1
          table.insert(highlights, {
            group = 'NonText',
            line = line_idx,
            col = hl_start_col,
            end_col = hl_start_col + 1,
          })
          hl_start_col = hl_start_col + 1
        end
        if fnameCount > 1 then
          local fnameFormatted = fnameFmt:format(fname)
          str = str .. fnameFormatted
          table.insert(highlights, {
            group = 'Directory',
            line = line_idx,
            col = hl_start_col,
            end_col = hl_start_col + #fnameFormatted - 1,
          })
          hl_start_col = hl_start_col + #fnameFormatted - 1
          table.insert(highlights, {
            group = 'NonText',
            line = line_idx,
            col = hl_start_col,
            end_col = hl_start_col + 1,
          })
          hl_start_col = hl_start_col + 1
          local numFormatted = ''
          if hasCol then
            numFormatted = lnumWithColFmt:format(lnumStr, colStr)
          elseif hasLnum then
            numFormatted = lnumFmt:format(lnumStr)
          end
          if #numFormatted > 0 then
            str = str .. numFormatted
            table.insert(highlights, {
              group = 'Number',
              line = line_idx,
              col = hl_start_col,
              end_col = hl_start_col + #numFormatted - 1,
            })
            hl_start_col = hl_start_col + #numFormatted - 1
            table.insert(highlights, {
              group = 'NonText',
              line = line_idx,
              col = hl_start_col,
              end_col = hl_start_col + 1,
            })
            hl_start_col = hl_start_col + 1
          end
        end
        local text = #e.text > 0 and e.text or ' '
        str = str .. textFmt:format(text)

        table.insert(ret, str)
    end
    -- Applying highlights has to be deferred, otherwise they won't apply to the
    -- lines inserted into the quickfix window.
    vim.schedule(function()
      apply_highlights(qf_bufnr, highlights)
    end)
    return ret
end

vim.o.qftf = '{info -> v:lua._G.qftf(info)}'
EOF
