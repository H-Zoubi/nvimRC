-- lua/config/lsp.lua

return {
	{
		"neovim/nvim-lspconfig",
		dependencies = { "hrsh7th/cmp-nvim-lsp" },
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local on_attach = function(client, bufnr)
				local map = function(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
				end

				map("n", "gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
				map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
			end

			-- --- LUA_LS SETUP (Existing) ---
			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						diagnostics = { globals = { "vim" } },
						workspace = { library = vim.api.nvim_get_runtime_file("", true) },
					},
				},
			})
			vim.lsp.enable("lua_ls")

			-- --- CLANGD SETUP (New for C/C++) ---
			vim.lsp.config("clangd", {
				capabilities = capabilities,
				on_attach = on_attach,
				-- Clangd needs a compile_commands.json file for large projects
				-- You typically generate this using a tool like CMake.
				-- If you see errors, make sure you have a compile_commands.json file
				-- in your project root or use a build tool to generate one.
			})

			-- Enable the clangd config for C, C++, and Objective-C filetypes
			vim.lsp.enable("clangd")
		end,
	},
}
