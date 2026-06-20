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
				map("n", "<leader>cD", vim.lsp.buf.declaration, "[C]ode [D]eclaration")
				map("n", "<leader>cr", vim.lsp.buf.references, "[C]ode [R]eferences")
				map("n", "<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
				map("n", "<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame Symbol")

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
				filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--completion-style=detailed",
					"--header-insertion=iwyu",
					"--function-arg-placeholders",
					"--fallback-style=llvm",
				},
				init_options = {
					clangdFileStatus = true,
					usePlaceholders = true,
					completeUnimported = true,
				},
			})

			-- Enable the clangd config for C, C++, and Objective-C filetypes
			vim.lsp.enable("clangd")

			-- --- PYRIGHT SETUP (Python) ---
			vim.lsp.config("pyright", {
				capabilities = capabilities,
				on_attach = on_attach,
			})
			vim.lsp.enable("pyright")
		end,
	},
}
