return {
	{ 
		"folke/tokyonight.nvim",
		priority = 1000 ,
		config = function()
			vim.o.background = "dark"
			vim.cmd("colorscheme tokyonight-night")
		end, 
		opts = {
			style = "night",
		},
	},
	{
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config= function()
	require('lualine').setup({
		options = {
			theme = "tokyonight",
		},
	})
    end,
    },
}
