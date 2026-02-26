-- Floating terminal with optional command runner
-- Place this file in your Neovim config (e.g. ~/.config/nvim/lua/float_terminal.lua)
-- Then require it from your init.lua: require("float_terminal")

local state = {
  floating = {
    buf = -1,
    win = -1,
    job = nil, -- terminal job id (if any)
  },
}

-- Function to open a floating window (returns table with buf and win)
local function OpenFloatingWindow(opts)
  opts = opts or {}
  local buf = nil
  if opts.buf and vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true) -- listed = false, scratch = true
  end

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local bufopts = {
    style = "minimal",
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    border = "rounded",
  }

  local win = vim.api.nvim_open_win(buf, true, bufopts)
  return { buf = buf, win = win }
end

-- Toggle floating terminal. If `cmd` (string) is provided, it will be executed inside the terminal.
-- Example: ToggleTerminal("pio run")
function ToggleTerminal(cmd)
  -- If window is open, close it (toggle off)
  if vim.api.nvim_win_is_valid(state.floating.win) then
    vim.api.nvim_win_close(state.floating.win, true)
    state.floating.win = -1
    return
  end

  -- Open floating window (re-using existing buffer if present)
  state.floating = OpenFloatingWindow({ buf = state.floating.buf })
  local buf = state.floating.buf
  local win = state.floating.win

  -- Ensure the newly opened window is current so termopen uses it
  vim.api.nvim_set_current_win(win)
  vim.api.nvim_set_current_buf(buf)

  -- If buffer is not yet a terminal, create one
  if vim.bo[buf].buftype ~= "terminal" then
    if cmd and #cmd > 0 then
      -- create terminal running provided cmd
      local job = vim.fn.termopen(cmd)
      -- store job id and buf
      state.floating.job = job
      state.floating.buf = buf
    else
      -- open an interactive terminal
      vim.cmd("term")
      -- after term created, get its job id if available
      state.floating.job = vim.b[buf].terminal_job_id or state.floating.job
      state.floating.buf = buf
    end
  else
    -- buffer is already a terminal
    -- try to get job id if we don't have it
    state.floating.job = state.floating.job or vim.b[buf].terminal_job_id
    if cmd and #cmd > 0 then
      -- if we have a job id, send the command to the terminal channel
      if state.floating.job and state.floating.job ~= 0 then
        vim.api.nvim_chan_send(state.floating.job, cmd .. "\n")
      else
        -- fallback: open a new terminal running the cmd in this buffer
        local job = vim.fn.termopen(cmd)
        state.floating.job = job
      end
    end
  end

  -- Enter insert mode in the terminal
  vim.cmd("startinsert")
end

-- Expose ToggleTerminal in module-style if required
local M = {
  ToggleTerminal = ToggleTerminal,
}

-- Keymaps:
-- Map <C-t> in normal and terminal to toggle the floating terminal (keeps previous behavior)
vim.keymap.set({ "n", "t" }, "<C-t>", ToggleTerminal, { desc = "Toggle floating terminal" })


-- Detect project type and return the appropriate run command
local function get_run_command()
  local cwd = vim.fn.getcwd()
  if vim.fn.filereadable(cwd .. "/platformio.ini") == 1 then
    return "pio run -t upload"
  elseif vim.fn.filereadable(cwd .. "/premake5.lua") == 1 then
    -- C++ premake project: generate makefiles, build, then run the produced binary
    return "premake5 gmake2 && make -j$(nproc) && BIN=$(find bin/ -maxdepth 2 -type f -executable 2>/dev/null | head -1) && [ -n \"$BIN\" ] && \"$BIN\" || echo 'Build succeeded but no executable found in bin/'"
  elseif vim.fn.filereadable(cwd .. "/main.py") == 1 then
    return "python3 main.py"
  else
    return nil
  end
end

vim.keymap.set("n", "<leader>rp", function()
  local cmd = get_run_command()
  if cmd then
    ToggleTerminal(cmd)
  else
    vim.notify("No recognized project type found (no platformio.ini, premake5.lua, or main.py)", vim.log.levels.WARN)
  end
end, { desc = "Run project (auto-detect: cpp/python/pio)" })


vim.keymap.set("n", "<leader>bp", function()
  ToggleTerminal("./run")
end, { desc = "Toggle floating terminal and run: pio run" })

vim.keymap.set("n", "<leader>sm", function()
  ToggleTerminal("pio device monitor -b115200")
end, { desc = "Toggle floating terminal and run: pio run" })

return M
