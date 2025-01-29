packadd! conform

lua <<EOF
require("conform").setup({
formatters_by_ft = {
  elixir = { "mix" , timeout_ms = 1500 },
},
format_after_save = function(bufnr)
  if vim.g.disable_conform or vim.b[bufnr].disable_conform then
    return
  end
  return { lsp_format = "fallback" }
end,
default_format_opts = {
  lsp_format = "fallback",
},
})

vim.api.nvim_create_user_command("ConformDisable", function(args)
  if args.bang then
    vim.b.disable_conform = true
  else
    vim.g.disable_conform = true
  end
end, {
  desc = "Disable Conform (bang for current buffer)",
  bang = true,
})

vim.api.nvim_create_user_command("ConformEnable", function()
  vim.b.disable_conform = false
  vim.g.disable_conform = false
end, {
  desc = "Re-enable Conform",
})

EOF
