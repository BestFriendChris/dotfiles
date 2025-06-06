---@type conform.FileFormatterConfig
return {
  meta = {
    url = "https://hexdocs.pm/mix/main/Mix.Tasks.Format.html",
    description = "Format Elixir files using the mix format command.",
  },
  command = "mix",
  args = { "format", "$FILENAME" },
  stdin = false,
  cwd = require("conform.util").root_file({
    "mix.exs",
  }),
}
