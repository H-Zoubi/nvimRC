local opt = vim.opt

-- Leader keys (must be set before lazy loads plugins)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- UI
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.termguicolors = true
opt.wrap = false
opt.scrolloff = 999
opt.sidescrolloff = 8
opt.splitright = true
opt.splitbelow = true
opt.showmode = false -- statusline plugin shows mode
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true

-- Editing
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
-- Apply four-column indentation after filetype plugins; Makefiles keep hard tabs.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("FourColumnIndent", { clear = true }),
  callback = function(event)
    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(event.buf) then
        return
      end
      local buf = event.buf
      vim.bo[buf].tabstop = 4
      vim.bo[buf].shiftwidth = 4
      vim.bo[buf].softtabstop = 4
      vim.bo[buf].expandtab = vim.bo[buf].filetype ~= "make"
    end)
  end,
})
opt.smartindent = true
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

-- Behavior
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.undofile = true
opt.swapfile = false
opt.backup = false
opt.updatetime = 250
opt.timeoutlen = 400
opt.completeopt = { "menu", "menuone", "noselect" }
opt.confirm = true -- ask to save instead of erroring on :q with unsaved changes

-- netrw (kept enabled alongside neo-tree; opens automatically on `nvim .`)
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3 -- tree view
vim.g.netrw_winsize = 25

-- Windows: use PowerShell for :! and terminal plugins (matches the default shell)
if vim.fn.has("win32") == 1 then
  opt.shell = "powershell"
  opt.shellcmdflag =
    "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
  opt.shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait"
  opt.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
  opt.shellquote = ""
  opt.shellxquote = ""
end
