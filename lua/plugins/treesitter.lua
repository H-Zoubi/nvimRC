-- Uses the rewritten nvim-treesitter (main branch, Neovim 0.12+): no more
-- `configs.setup{}`; highlighting/indent/folds are wired up via autocmds
-- that call the built-in vim.treesitter.* functions directly.
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  lazy = false, -- this plugin does not support lazy-loading
  config = function()
    local ensure_installed = {
      "c",
      "cpp",
      "cmake",
      "python",
      "lua",
      "vim",
      "vimdoc",
      "query",
      "bash",
      "json",
      "yaml",
      "toml",
      "markdown",
      "markdown_inline",
      "regex",
      "printf",
    }
    require("nvim-treesitter").install(ensure_installed)

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("Treesitter", { clear = true }),
      callback = function()
        pcall(vim.treesitter.start)
        pcall(function()
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end)
        vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo[0][0].foldmethod = "expr"
      end,
    })
  end,
}
