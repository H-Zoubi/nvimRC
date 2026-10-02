return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  opts = {
    flavour = "mocha",
    background = {
      light = "latte",
      dark = "mocha",
    },
    integrations = {
      cmp = true,
      gitsigns = true,
      nvimtree = true,
      treesitter = true,
      telescope = {
        enabled = true,
      },
      native_lsp = {
        enabled = true,
      },
    },
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.o.background = "dark"
    vim.cmd.colorscheme("catppuccin")
  end,
}
