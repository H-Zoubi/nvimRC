local cpp_style = require("config.cpp_style")

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true, lsp_format = "fallback" })
      end,
      mode = "",
      desc = "Format buffer",
    },
  },
  opts = {
    formatters = {
      clang_format = { prepend_args = { "--style=" .. cpp_style } },
      stylua = { prepend_args = { "--indent-type", "Spaces", "--indent-width", "4" } },
      cmake_format = { prepend_args = { "--tab-size", "4" } },
    },
    notify_on_error = false,
    format_on_save = function(_bufnr)
      return { timeout_ms = 2000, lsp_format = "fallback" }
    end,
    formatters_by_ft = {
      c = { "clang_format" },
      cpp = { "clang_format" },
      python = { "ruff_format" },
      lua = { "stylua" },
      cmake = { "cmake_format" },
    },
  },
}
