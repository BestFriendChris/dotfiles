packadd! nvim-treesitter

function! s:EnsureTreeSitter() abort
  let expected = [
        \  "awk",
        \  "bash",
        \  "comment",
        \  "css",
        \  "diff",
        \  "dockerfile",
        \  "eex",
        \  "elixir",
        \  "erlang",
        \  "git_config",
        \  "git_rebase",
        \  "gitattributes",
        \  "gitcommit",
        \  "gitignore",
        \  "go",
        \  "heex",
        \  "html",
        \  "http",
        \  "javascript",
        \  "json",
        \  "json5",
        \  "lua",
        \  "luadoc",
        \  "make",
        \  "nix",
        \  "python",
        \  "regex",
        \  "ruby",
        \  "rust",
        \  "scss",
        \  "sql",
        \  "svelte",
        \  "terraform",
        \  "toml",
        \  "typescript",
        \  "vim",
        \  "vimdoc",
        \  "yaml",
        \  "zig",
        \  "query",
        \ ]

  let installed = map(
    \ nvim_get_runtime_file("parser/*.so", v:true),
    \ { _, val -> substitute(val, '^.*/parser/\([^.]*\)\.so', '\=submatch(1)', '') }
    \ )

  let to_install = {}
  let to_uninstall = {}
  for want in expected
    let to_install[want] = v:true
  endfor
  for already in installed
    if has_key(to_install, already)
      unlet to_install[already]
    endif
  endfor

  for i in keys(to_install)
    echom "Installing ".i
    execute "TSInstallSync " . i
  endfor

  echom "Calling TSUpdate"
  TSUpdate
  echom "Done"
endfunction

call bfc#install#register("EnsureTreeSitter", funcref('<SID>EnsureTreeSitter'))
command! BfcEnsureTreeSitter call s:EnsureTreeSitter()

function! s:TreeSitterSetup() abort
  lua <<EOF
  require'nvim-treesitter.configs'.setup {
    auto_install = true,
    highlight = {
      enable = true
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "gnn",
        node_incremental = "grn",
        scope_incremental = "grc",
        node_decremental = "grm",
      },
    },
    indent = {
      enable = true,
    },
  }
EOF

  set foldmethod=expr
  set foldexpr=nvim_treesitter#foldexpr()

endfunction

call bfc#plugins#on_load(funcref('<SID>TreeSitterSetup'))
