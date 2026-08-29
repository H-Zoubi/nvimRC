return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  dependencies = { "mason-org/mason.nvim" },
  event = "VeryLazy",
  opts = {
    ensure_installed = {
      -- formatters
      "clang-format",
      "stylua",
      "cmakelang", -- provides the cmake-format binary
      "ruff",
      -- debuggers
      "codelldb", -- native launch/attach debugging for desktop C/C++
      "cpptools", -- OpenDebugAD7 adapter, used for embedded gdbserver debugging
      "debugpy",
    },
  },
}
