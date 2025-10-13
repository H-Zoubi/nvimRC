-- ~/.config/nvim/lua/plugins/conform.lua
return {
	"stevearc/conform.nvim",
	opts = {
		format_on_save = false, -- disabled to prevent reverts

		formatters_by_ft = {
			c = { "clang-format" },
			cpp = { "clang-format" },
		},

		formatters = {
			["clang-format"] = {
				args = {
					"--style={BasedOnStyle: LLVM, IndentWidth: 4, TabWidth: 4, UseTab: Never, BreakBeforeBraces: Allman, AllowShortIfStatementsOnASingleLine: false, IndentCaseLabels: false, PointerAlignment: Left, ReferenceAlignment: Left, NamespaceIndentation: All, ColumnLimit: 0, SkipMacroDefinitionBody: true, MaxEmptyLinesToKeep: 1, SeparateDefinitionBlocks: Leave}",
					"$FILENAME",
				},
			},
		},
	},

	config = function(_, opts)
		require("conform").setup(opts)

		vim.api.nvim_set_keymap(
			"n", -- normal mode
			"<leader>F",
			"<cmd>lua require('conform').format()<CR>",
			{ noremap = true, silent = true }
		)
	end,
}
