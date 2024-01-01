packadd! vim-go

let g:go_template_autocreate = 0

lua << EOF
local config = {
  ["go.mod"] = {
    ["*.go"] = {
      type = "source",
      alternate = "{}_test.go",
      dispatch = "go test ./{dirname}",
      template = {
        "package {dirname|basename}",
      },
    },
    ["*_test.go"] = {
      type = "test",
      alternate = "{}.go",
      template = {
        "package {dirname|basename}",
        "",
        "import (",
        "  \"testing\"",
        ")",
        "",
        "func Test(t *testing.T) {open}",
        "  t.Fatal(`Not Yet Implemented`)",
        "{close}",
      },
    },
    ["cmd/*.go"] = {
      type = "cmd",
      start = "go run ./{dirname}",
      template = {
        "package main",
        "",
        "func main() {open}",
        "  ",
        "{close}",
      },
    },
    ["*"] = {
      make = "go test ./...",
    },
  },
}

local new_heuristics
if vim.g.projectionist_heuristics then
  new_heuristics = vim.tbl_extend("force", vim.g.projectionist_heuristics, config)
else
  new_heuristics = config
end
vim.g.projectionist_heuristics = new_heuristics
EOF


function! s:GolangMappings() abort
  nnoremap <buffer> <silent> \\ <Cmd>A<CR>
endfunction

function! s:GolangTestMappings() abort
  nnoremap <buffer> <silent> '. <Cmd>GoTestFunc<CR>
endfunction

augroup bfcGolang
  autocmd!
  autocmd BufNewFile,BufReadPost *.go call s:GolangMappings()
  autocmd BufNewFile,BufReadPost *_test.go call s:GolangTestMappings()
augroup end
