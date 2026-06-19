local function map(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, opts or {})
end

local function del(mode, lhs)
  pcall(vim.keymap.del, mode, lhs)
end

local default_conflicts = {
  "<leader>e",
  "<leader>q",
  "<leader>ff",
  "<leader>fg",
  "<leader>fs",
  "<leader>fb",
  "<leader>fk",
  "<leader>fd",
  "<leader>fh",
  "<C-h>",
  "<C-j>",
  "<C-k>",
  "<C-l>",
  "<C-b>",
}

for _, key in ipairs(default_conflicts) do
  del("n", key)
end

map("n", "<M-e>", ":Ex<CR>", { desc = "Open netrw" })
map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic quickfix list" })
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

local function find_git_files()
  local builtin = require("telescope.builtin")
  local ok = pcall(builtin.git_files)
  if not ok then
    builtin.find_files()
  end
end

local function find_all_files()
  require("telescope.builtin").find_files({
    hidden = true,
    no_ignore = true,
    no_ignore_parent = true,
    follow = true,
  })
end

map("n", "<leader>ff", find_all_files, { desc = "Telescope find all files" })
map("n", "<leader>gr", function()
  require("telescope.builtin").lsp_references()
end, { desc = "Telescope find references" })
map("n", "<leader>fg", find_git_files, { desc = "Telescope find git files" })
map("n", "<leader>fs", function()
  require("telescope.builtin").lsp_document_symbols()
end, { desc = "Telescope find symbols" })
map("n", "<leader>fS", function()
  require("telescope.builtin").live_grep()
end, { desc = "Telescope find string" })
map("n", "<leader>fw", function()
  require("telescope.builtin").grep_string()
end, { desc = "Telescope grep string" })
map("n", "<leader>fb", function()
  require("telescope.builtin").buffers()
end, { desc = "Telescope buffers" })
map("n", "<leader>fk", function()
  require("telescope.builtin").keymaps()
end, { desc = "Find keymaps" })
map("n", "<leader>fd", function()
  require("telescope.builtin").diagnostics()
end, { desc = "Find diagnostics" })
map("n", "<leader>fh", function()
  require("telescope.builtin").help_tags()
end, { desc = "Telescope help tags" })
map("n", "<C-b>", "<C-^>", { desc = "Go to previous buffer" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic message" })

local function ensure_cpp_exists()
  local header = vim.fn.expand("%")
  local source = vim.fn.expand("%:r") .. ".cpp"

  if vim.fn.filereadable(source) == 0 then
    local f = io.open(source, "w")
    if f then
      local header_file = vim.fn.fnamemodify(header, ":t")
      f:write('#include "' .. header_file .. '"\n\n')
      f:close()
    end
  end

  return source
end

map("v", "<leader>cm", function()
  local cpp_file = ensure_cpp_exists()
  local start_pos = vim.fn.getpos("'<")[2]
  local end_pos = vim.fn.getpos("'>")[2]
  vim.cmd(string.format("%d,%dTSCppDefineClassFunc", start_pos, end_pos))
  vim.cmd("edit " .. cpp_file)
end, { noremap = true, silent = true, desc = "Code generate methods" })

map("n", "<leader>cm", function()
  local cpp_file = ensure_cpp_exists()
  vim.cmd("TSCppDefineClassFunc")
  vim.cmd("edit " .. cpp_file)
end, { noremap = true, silent = true, desc = "Code generate methods" })

local terminal = require("config.termnl")
map({ "n", "t" }, "<C-t>", terminal.toggle_terminal, { desc = "Toggle floating terminal" })
map("n", "<leader>rp", terminal.run_detected_project, { desc = "Run project (auto-detect)" })
map("n", "<leader>bp", function()
  terminal.toggle_terminal("./run")
end, { desc = "Run ./run in floating terminal" })
map("n", "<leader>sm", function()
  terminal.toggle_terminal("pio device monitor -b115200")
end, { desc = "Run serial monitor" })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local opts = { buffer = args.buf }
    pcall(vim.keymap.del, "n", "gd", { buffer = args.buf })
    pcall(vim.keymap.del, "n", "K", { buffer = args.buf })
    pcall(vim.keymap.del, "n", "<leader>cD", { buffer = args.buf })
    pcall(vim.keymap.del, "n", "<leader>cr", { buffer = args.buf })
    pcall(vim.keymap.del, "n", "<leader>ca", { buffer = args.buf })
    pcall(vim.keymap.del, "n", "<leader>rn", { buffer = args.buf })
    map("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Goto definition" }))
    map("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
    map("n", "<leader>cD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Code declaration" }))
    map("n", "<leader>cr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Code references" }))
    map("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
    map("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
  end,
})
