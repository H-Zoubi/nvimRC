return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "theHamsta/nvim-dap-virtual-text",
    "mfussenegger/nvim-dap-python",
    "mason-org/mason.nvim",
  },
  -- VS-style function keys, since that's the muscle memory this config targets
  keys = {
    { "<F5>", function() require("dap").continue() end, desc = "Debug: Start/Continue" },
    { "<S-F5>", function() require("dap").terminate() end, desc = "Debug: Stop" },
    { "<leader>dl", function() require("dap").run_last() end, desc = "Debug: Run last" },
    { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle breakpoint" },
    {
      "<leader>db",
      function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
      desc = "Debug: Conditional breakpoint",
    },
    { "<F10>", function() require("dap").step_over() end, desc = "Debug: Step over" },
    { "<F11>", function() require("dap").step_into() end, desc = "Debug: Step into" },
    { "<S-F11>", function() require("dap").step_out() end, desc = "Debug: Step out" },
    { "<leader>du", function() require("dapui").toggle() end, desc = "Debug: Toggle UI" },
    { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Debug: Toggle REPL" },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup()
    require("nvim-dap-virtual-text").setup()

    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
    vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticInfo", linehl = "Visual" })

    local mason_pkg_path = vim.fn.stdpath("data") .. "/mason/packages"
    local is_win = vim.fn.has("win32") == 1

    -- codelldb: everyday desktop/CMake C++ launch & attach debugging
    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = {
        command = mason_pkg_path .. "/codelldb/extension/adapter/codelldb" .. (is_win and ".exe" or ""),
        args = { "--port", "${port}" },
      },
    }

    -- cpptools' OpenDebugAD7: used for attaching to a remote gdbserver
    -- (OpenOCD / J-Link / Black Magic Probe), the standard PlatformIO/embedded flow
    dap.adapters.cppdbg = {
      id = "cppdbg",
      type = "executable",
      command = mason_pkg_path .. "/cpptools/extension/debugAdapters/bin/OpenDebugAD7" .. (is_win and ".exe" or ""),
    }

    dap.configurations.cpp = {
      {
        name = "Launch executable (codelldb)",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/build/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = {},
      },
      {
        -- Start your board's gdbserver (openocd, JLinkGDBServer, blackmagic, ...)
        -- first, then run this. Adjust miDebuggerPath/Address for your setup.
        name = "Attach to gdbserver (embedded / PlatformIO)",
        type = "cppdbg",
        request = "launch",
        program = function()
          return vim.fn.input("Path to .elf: ", vim.fn.getcwd() .. "/.pio/build/", "file")
        end,
        cwd = "${workspaceFolder}",
        MIMode = "gdb",
        miDebuggerPath = "arm-none-eabi-gdb", -- adjust to your toolchain's gdb
        miDebuggerServerAddress = "localhost:3333",
        stopAtEntry = true,
        setupCommands = {
          { text = "-enable-pretty-printing", description = "enable pretty printing", ignoreFailures = false },
        },
      },
    }
    dap.configurations.c = dap.configurations.cpp

    -- debugpy, installed by Mason into its own venv
    local py_path = mason_pkg_path .. "/debugpy/venv/" .. (is_win and "Scripts/python.exe" or "bin/python")
    require("dap-python").setup(py_path)
  end,
}
