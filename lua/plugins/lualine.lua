return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      theme = "auto", -- detects the active colorscheme (tokyonight ships a
                       -- lualine theme, so this resolves correctly)
      globalstatus = true,
      icons_enabled = true,
    },
    sections = {
      lualine_c = { { "filename", path = 1 } },
      lualine_x = { "diagnostics", "encoding", "filetype" },
    },
  },
}
