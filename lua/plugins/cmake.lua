return {
  "Civitasv/cmake-tools.nvim",
  ft = { "cpp", "c", "cmake" },
  dependencies = { "mfussenegger/nvim-dap" },
  keys = {
    { "<F7>", "<cmd>CMakeBuild<CR>", desc = "CMake: Build" },
    { "<C-F5>", "<cmd>CMakeRun<CR>", desc = "CMake: Run" },
    { "<leader>cg", "<cmd>CMakeGenerate<CR>", desc = "CMake: Generate/configure" },
    { "<leader>cb", "<cmd>CMakeBuild<CR>", desc = "CMake: Build" },
    { "<leader>cr", "<cmd>CMakeRun<CR>", desc = "CMake: Run" },
    { "<leader>cd", "<cmd>CMakeDebug<CR>", desc = "CMake: Debug" },
    { "<leader>cs", "<cmd>CMakeSelectBuildType<CR>", desc = "CMake: Select build type" },
    { "<leader>ct", "<cmd>CMakeSelectBuildTarget<CR>", desc = "CMake: Select target" },
    { "<leader>cl", "<cmd>CMakeSelectLaunchTarget<CR>", desc = "CMake: Select launch target" },
    { "<leader>cc", "<cmd>CMakeClean<CR>", desc = "CMake: Clean" },
    { "<leader>cq", "<cmd>CMakeCloseExecutor<CR>", desc = "CMake: Close executor" },
  },
  opts = {
    cmake_build_directory = "build/${variant:buildType}",
    cmake_soft_link_compile_commands = true,
    cmake_dap_configuration = {
      name = "cpp",
      type = "codelldb",
      request = "launch",
    },
  },
}
