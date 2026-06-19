local state = {
  floating = {
    buf = -1,
    win = -1,
    job = nil,
  },
}

local function open_floating_window(opts)
  opts = opts or {}
  local buf
  if opts.buf and vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    style = "minimal",
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    border = "rounded",
  })

  return { buf = buf, win = win }
end

local function toggle_terminal(cmd)
  if vim.api.nvim_win_is_valid(state.floating.win) then
    vim.api.nvim_win_close(state.floating.win, true)
    state.floating.win = -1
    return
  end

  state.floating = open_floating_window({ buf = state.floating.buf })
  local buf = state.floating.buf
  local win = state.floating.win

  vim.api.nvim_set_current_win(win)
  vim.api.nvim_set_current_buf(buf)

  if vim.bo[buf].buftype ~= "terminal" then
    if cmd and #cmd > 0 then
      state.floating.job = vim.fn.termopen(cmd)
      state.floating.buf = buf
    else
      vim.cmd("term")
      state.floating.job = vim.b[buf].terminal_job_id or state.floating.job
      state.floating.buf = buf
    end
  else
    state.floating.job = state.floating.job or vim.b[buf].terminal_job_id
    if cmd and #cmd > 0 then
      if state.floating.job and state.floating.job ~= 0 then
        vim.api.nvim_chan_send(state.floating.job, cmd .. "\n")
      else
        state.floating.job = vim.fn.termopen(cmd)
      end
    end
  end

  vim.cmd("startinsert")
end

local function get_run_command()
  local cwd = vim.fn.getcwd()
  if vim.fn.filereadable(cwd .. "/platformio.ini") == 1 then
    return "pio run -t upload"
  elseif vim.fn.filereadable(cwd .. "/premake5.lua") == 1 then
    return "premake5 gmake2 && make -j$(nproc) && BIN=$(find bin/ -maxdepth 2 -type f -executable 2>/dev/null | head -1) && [ -n \"$BIN\" ] && \"$BIN\" || echo 'Build succeeded but no executable found in bin/'"
  elseif vim.fn.filereadable(cwd .. "/main.py") == 1 then
    return "python3 main.py"
  end

  return nil
end

local function run_detected_project()
  local cmd = get_run_command()
  if cmd then
    toggle_terminal(cmd)
  else
    vim.notify("No recognized project type found (no platformio.ini, premake5.lua, or main.py)", vim.log.levels.WARN)
  end
end

return {
  toggle_terminal = toggle_terminal,
  run_detected_project = run_detected_project,
}
