return {
  "loctvl842/monokai-pro.nvim",
  lazy = false, -- colorscheme plugins must load eagerly; priority alone doesn't do it
  priority = 1000,
  opts = {
    -- "spectrum" gives each token category (types, keywords, functions,
    -- strings, numbers, ...) its own distinct hue instead of sharing colors
    filter = "spectrum", -- pro | octagon | machine | ristretto | spectrum | classic
  },
  config = function(_, opts)
    require("monokai-pro").setup(opts)
    vim.cmd.colorscheme("monokai-pro")
  end,
}
