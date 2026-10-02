return {
  'ggml-org/llama.vim',
  lazy = false,
  init = function()
    vim.g.llama_config = {
      endpoint_fim = 'http://127.0.0.1:8012/infill',
      auto_fim = true,
      fim_debounce_ms = 300,
      show_info = 0,
    }

    local group = vim.api.nvim_create_augroup('LlamaThemeHighlights', { clear = true })
    local function apply_highlights()
      vim.api.nvim_set_hl(0, 'llama_hl_fim_hint', { link = 'Comment' })
      vim.api.nvim_set_hl(0, 'llama_hl_fim_info', { link = 'NonText' })
    end

    apply_highlights()
    vim.api.nvim_create_autocmd('ColorScheme', {
      group = group,
      callback = apply_highlights,
    })
  end,
}
