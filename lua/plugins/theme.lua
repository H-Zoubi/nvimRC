return {
	{ 
		"ellisonleao/gruvbox.nvim",
		priority = 1000 ,
		config = function()
			vim.o.background = "dark" -- or "light" for light mode
			vim.cmd("colorscheme gruvbox")
		end, 
		opts = ...
	},
	{
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config= function()
	require('lualine').setup()
    end,
    },
}

