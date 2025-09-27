-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' }) -- find files
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' }) -- find word / string in files
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' }) -- find in currently open buffers
vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[F]ind [K]eymaps' }) -- find in keymaps
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[F]ind [D]iagnostics' }) -- find in diagnosticls
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' }) -- fin in help / docs
