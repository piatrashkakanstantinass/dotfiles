local M = {}

function M.setup()
  vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
      local buf = vim.api.nvim_get_current_buf()
      vim.lsp.buf.format({
        bufnr = buf
      })
    end
  })
end

return M
