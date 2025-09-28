local state = {
	floating = {
		buf = -1,
		win = -1,
	},
}

-- Function to open a floating window
local function OpenFloatingWindow(opts)
	opts = opts or {}
	-- create a new buffer
	local buf = nil
	if vim.api.nvim_buf_is_valid(opts.buf) then
		buf = opts.buf
	else
		buf = vim.api.nvim_create_buf(false, true)
	end

	-- calculate dimensions (80% of screen)
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	-- window options
	local opts = {
		style = "minimal",
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		border = "rounded",
	}

	-- open floating window
	local win = vim.api.nvim_open_win(buf, true, opts)
	return { buf = buf, win = win }
end

function ToggleTerminal()
	if not vim.api.nvim_win_is_valid(state.floating.win) then
		state.floating = OpenFloatingWindow({ buf = state.floating.buf })
		if vim.bo[state.floating.buf].buftype ~= "terminal" then
			vim.cmd.term()
		end
		vim.cmd("startinsert")
	else
		vim.api.nvim_win_hide(state.floating.win)
	end
end

vim.api.nvim_create_user_command("FloatTerminal", ToggleTerminal, {})
-- Map <C-t> to open floating window
vim.keymap.set({ "n", "t" }, "<C-t>", ToggleTerminal, { desc = "Open floating window" })
