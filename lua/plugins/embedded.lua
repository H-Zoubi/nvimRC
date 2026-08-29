-- PlatformIO workflow. clangd needs a compile_commands.json to understand
-- embedded builds (custom toolchains, defines, include paths) -- `pio run
-- -t compiledb` generates one; run it whenever platformio.ini changes.
return {
  "akinsho/toggleterm.nvim",
  version = "*",
  cmd = "ToggleTerm",
  keys = {
    { "<leader>pb", "<cmd>PioBuild<CR>", desc = "PlatformIO: Build" },
    { "<leader>pu", "<cmd>PioUpload<CR>", desc = "PlatformIO: Upload" },
    { "<leader>pm", "<cmd>PioMonitor<CR>", desc = "PlatformIO: Serial monitor" },
    { "<leader>pc", "<cmd>PioCompiledb<CR>", desc = "PlatformIO: Regenerate compile_commands.json" },
    { "<leader>pt", "<cmd>PioClean<CR>", desc = "PlatformIO: Clean" },
    { "<leader>p`", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal" },
    { "<C-t>", "<cmd>ToggleTerm<CR>", mode = { "n", "t" }, desc = "Toggle floating terminal" },
  },
  opts = {
    direction = "float",
    close_on_exit = false,
    float_opts = { border = "rounded" },
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)
    local Terminal = require("toggleterm.terminal").Terminal

    local function run(cmd)
      Terminal:new({ cmd = cmd, direction = "float", close_on_exit = false }):toggle()
    end

    local function pio_cmd(name, cmd)
      vim.api.nvim_create_user_command(name, function()
        run(cmd)
      end, {})
    end

    pio_cmd("PioBuild", "pio run")
    pio_cmd("PioUpload", "pio run -t upload")
    pio_cmd("PioMonitor", "pio device monitor")
    pio_cmd("PioCompiledb", "pio run -t compiledb")
    pio_cmd("PioClean", "pio run -t clean")
  end,
}
