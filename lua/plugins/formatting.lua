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
    notify_on_error = false,
    format_on_save = function(bufnr)
      local disable_ft = { c = true, cpp = true } -- clang-format can be slow/opinionated; format on demand instead
      if disable_ft[vim.bo[bufnr].filetype] then
        return nil
      end
      return { timeout_ms = 1000, lsp_format = "fallback" }
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
