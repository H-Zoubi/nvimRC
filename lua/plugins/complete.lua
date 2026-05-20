-- lua/config/completion.lua

return {
    {
        "github/copilot.vim",
        config = function ()
            vim.g.copilot_no_tab_map = true
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
					["<C-y>"] = cmp.mapping(function(fallback)
						local ok_visible, copilot_visible = pcall(vim.fn["copilot#Visible"])
						if ok_visible and copilot_visible == 1 then
							-- Copilot returns accepted text when a suggestion is visible, else an empty fallback.
							local ok_accept, copilot_accept = pcall(vim.fn["copilot#Accept"], "")
							if ok_accept and type(copilot_accept) == "string" then
								local keys = vim.api.nvim_replace_termcodes(copilot_accept, true, true, true)
								if keys ~= "" then
									vim.api.nvim_feedkeys(keys, "n", false)
									return
								end
							end
						end
						if cmp.visible() then
							cmp.confirm({ select = true })
							return
						end
						fallback()
					end, { "i", "s" }),
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
