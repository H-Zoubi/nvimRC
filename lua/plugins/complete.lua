-- lua/config/completion.lua

return {
    {
        "github/copilot.vim",
        config = function ()
        end
    },
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- Source for LSP
			"hrsh7th/cmp-buffer", -- Source for current buffer words
			"hrsh7th/cmp-path", -- Source for file paths
		},
		config = function()
			local cmp = require("cmp")

			-- Minimal recommended Neovim option
			vim.opt.completeopt = { "menu", "menuone", "noselect" }

			cmp.setup({
				-- No snippet engine setup

				mapping = cmp.mapping.preset.insert({
					["<C-y>"] = cmp.mapping.confirm({ select = true }),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),
				}),

				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "buffer" },
					{ name = "path" },
				}),
			})
		end,
	},
}
