vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = false

vim.o.number = true

vim.o.mouse = "a"

vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.signcolumn = "yes"

vim.o.updatetime = 250

vim.o.splitright = true
vim.o.splitbelow = true

--  TODO::Change?
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.o.inccommand = "split"
vim.o.cursorline = true
vim.o.scrolloff = 15 -- TODO::Edit based on prefrence

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Enable folding based on Treesitter
vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldlevel = 99 -- start with all folds open
