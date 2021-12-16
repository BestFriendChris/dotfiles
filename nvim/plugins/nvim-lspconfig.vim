packadd! nvim-lspconfig
packadd! nvim-lsp-installer

lua << EOF
vim.g.bfc_lsp_servers = {
  elixir="elixirls",
  --ruby="solargraph",
}

local lsp_installer = require("nvim-lsp-installer")
lsp_installer.settings {
  ui = {
    icons = {
      server_installed = "✓",
      server_pending = "➜",
      server_uninstalled = "✗"
    }
  }
}

lsp_installer.on_server_ready(function(server)
  local opts = {}
  server:setup(opts)
end)
EOF

function! s:InstallLspServers() abort
lua << EOF
  local lsp_installer = require "nvim-lsp-installer"

  local servers = vim.g.bfc_lsp_servers

  for lang, name in pairs(servers) do
    local server_is_found, server = lsp_installer.get_server(name)
    if server_is_found then
      if not server:is_installed() then
        print("Installing LspServer '" .. name .. "' (" .. lang .. ")")
        server:install()
      else
        print("Updating LspServer '" .. name .. "' (" .. lang .. ")")
        server:install()
      end
    end
  end
EOF
endfunction

call bfc#install#register("InstallLspServers", funcref('<SID>InstallLspServers'))
