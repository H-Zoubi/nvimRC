return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-night",
    },
  },
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "night",
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.options = opts.options or {}
      opts.options.theme = "tokyonight"
      return opts
    end,
  },
}
