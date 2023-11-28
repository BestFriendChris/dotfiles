packadd! bqf

lua << EOF
require('bqf').setup({
  func_map = {
    tabdrop = '<C-t>',
    tabc = '',
  }
})


local fn = vim.fn

function _G.qftf(info)
    local items
    local ret = {}

    if info.quickfix == 1 then
        items = fn.getqflist({id = info.id, items = 0}).items
    else
        items = fn.getloclist(info.winid, {id = info.id, items = 0}).items
    end

    local fnames = {}
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
      hasLnum = hasLnum or e.lnum >= 0
      local lnum = e.lnum > 99999 and -1 or e.lnum
      lnumLength = math.max(lnumLength, #tostring(lnum))
      hasCol = hasCol or e.col >= 0
      local col = e.col > 999 and -1 or e.col
      colLength = math.max(colLength, #tostring(col))
    end

    local fnameCount = 0
    local fnameLength = 0

    for fname, _ in pairs(fnames) do
      fnameCount = fnameCount + 1
      fnameLength = math.max(fnameLength, #fname)
    end

    vim.cmd.echomsg('"fnameCount: ' .. fnameCount .. ' fnameLength: ' .. fnameLength .. ' lnumLength: ' .. lnumLength .. ' colLength: ' .. colLength .. '"')

    local limit = math.min(31, fnameLength)
    local fnameFmt1, fnameFmt2 = '%-' .. limit .. 's', '…%.' .. (limit - 1) .. 's'
    local validFmt = '%s │'
    if hasLnum then
      validFmt = validFmt .. '%' .. lnumLength .. 'd'
    end
    if hasCol then
      validFmt = validFmt .. ':%-' .. colLength .. 'd'
    end
    if hasLnum or hasCol then
      validFmt = validFmt .. '│'
    end
    validFmt = validFmt .. '%s %s'
    for i = info.start_idx, info.end_idx do
        local e = items[i]
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
        local qtype = e.type == '' and '' or ' ' .. e.type:sub(1, 1):upper()
        if fnameCount > 1 then
          if hasLnum and hasCol then
            str = validFmt:format(fname, lnum, col, qtype, e.text)
          elseif hasLnum then
            str = validFmt:format(fname, lnum, qtype, e.text)
          elseif hasCol then
            str = validFmt:format(fname, col, qtype, e.text)
          else
            str = validFmt:format(fname, qtype, e.text)
          end
        else
          str = e.text
        end
        table.insert(ret, str)
    end
    return ret
end

vim.o.qftf = '{info -> v:lua._G.qftf(info)}'
EOF
