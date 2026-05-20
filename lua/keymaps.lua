-- Telescope
local builtin = require("telescope.builtin")

local function find_git_files()
	local ok = pcall(builtin.git_files)
	if not ok then
		builtin.find_files()
	end
end

local function find_all_files()
	builtin.find_files({
		hidden = true,
		no_ignore = true,
		no_ignore_parent = true,
		follow = true,
	})
end

vim.keymap.set("n", "<leader>ff", find_all_files, { desc = "Telescope find all files" }) -- find all files
vim.keymap.set("n", "<leader>gr", builtin.lsp_references, { desc = "Telescope find references" }) -- find files
vim.keymap.set("n", "<leader>fg", find_git_files, { desc = "Telescope find git files" }) -- find git files
vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Telescope find symbols" }) -- find symbols
vim.keymap.set("n", "<leader>fS", builtin.live_grep, { desc = "Telescope find string" }) -- find string in files
vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "grep string" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" }) -- find in currently open buffers
vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "[F]ind [K]eymaps" }) -- find in keymaps
vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "[F]ind [D]iagnostics" }) -- find in diagnostics
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" }) -- find in help / docs
vim.keymap.set("n", "<C-b>", "<C-^>", { desc = "Go to previous buffer" })
vim.keymap.set("n", "<leader>e", function()
	vim.diagnostic.open_float()
end, { desc = "Show error message" })

vim.keymap.set("n", "<leader>ca", function()
	vim.lsp.buf.code_action()
end, { desc = "Code Action" })

-- C++ tools::

-- Function: create cpp if missing, without leaving header buffer
local function ensure_cpp_exists()
	local header = vim.fn.expand("%") -- full path to header
	local source = vim.fn.expand("%:r") .. ".cpp" -- corresponding cpp

	if vim.fn.filereadable(source) == 0 then
		-- create file without leaving header buffer
		local f = io.open(source, "w")
		if f then
			local header_file = vim.fn.fnamemodify(header, ":t")
			f:write('#include "' .. header_file .. '"\n\n')
			f:close()
		end
	end
	return source
end

-- Visual-mode mapping: create cpp if missing, then run Treesitter command
vim.keymap.set("v", "<leader>cm", function()
	-- Ensure .cpp file exists
	local cpp_file = ensure_cpp_exists()

	-- Get visual selection start/end in header buffer
	local start_pos = vim.fn.getpos("'<")[2]
	local end_pos = vim.fn.getpos("'>")[2]

	-- Run Treesitter C++ plugin on the selection
	vim.cmd(string.format("%d,%dTSCppDefineClassFunc", start_pos, end_pos))

	-- Open the cpp file in current window after generating
	vim.cmd("edit " .. cpp_file)
end, { noremap = true, silent = true, desc = "[C]ode Generate [M]ethods" })

-- Normal-mode mapping: generate functions for the class under cursor
vim.keymap.set("n", "<leader>cm", function()
	-- Ensure cpp file exists first
	local cpp_file = ensure_cpp_exists()

	-- Run Treesitter C++ plugin for the current node (cursor position)
	vim.cmd("TSCppDefineClassFunc")

	-- Open the cpp file in the current window
	vim.cmd("edit " .. cpp_file)
end, { noremap = true, silent = true, desc = "[C]ode Generate [M]ethods" })
