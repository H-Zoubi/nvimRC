return {
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns
					local opts = { buffer = bufnr, noremap = true, silent = true }

					-- Navigation
					vim.keymap.set("n", "]c", gs.next_hunk, opts)
					vim.keymap.set("n", "[c", gs.prev_hunk, opts)

					-- Actions
					vim.keymap.set("n", "<leader>hs", gs.stage_hunk, opts) -- stage hunk
					vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk, opts) -- undo stage hunk
					vim.keymap.set("n", "<leader>hr", gs.reset_hunk, opts) -- reset hunk
					vim.keymap.set("n", "<leader>hb", gs.blame_line, opts) -- blame current line

					-- Preview
					vim.keymap.set("n", "<leader>hp", gs.preview_hunk, opts) -- preview hunk

					-- Optional: text object for visual selection
					vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", opts)
				end,
			})
		end,
	},
}
