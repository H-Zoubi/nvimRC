return {
  {
    "mg979/vim-visual-multi",
    branch = "master",
    event = "VeryLazy",
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = function(_, opts)
      opts = opts or {}
      local previous_on_attach = opts.on_attach
      opts.on_attach = function(bufnr)
        if previous_on_attach then
          previous_on_attach(bufnr)
        end

        local gs = package.loaded.gitsigns
        local map_opts = { buffer = bufnr, noremap = true, silent = true }

        vim.keymap.set("n", "]c", gs.next_hunk, map_opts)
        vim.keymap.set("n", "[c", gs.prev_hunk, map_opts)
        vim.keymap.set("n", "<leader>hs", gs.stage_hunk, map_opts)
        vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk, map_opts)
        vim.keymap.set("n", "<leader>hr", gs.reset_hunk, map_opts)
        vim.keymap.set("n", "<leader>hb", gs.blame_line, map_opts)
        vim.keymap.set("n", "<leader>hp", gs.preview_hunk, map_opts)
        vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", map_opts)
      end

      return opts
    end,
  },
}
