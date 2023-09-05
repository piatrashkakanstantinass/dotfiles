return {
  {
    "nvim-tree/nvim-tree.lua",
    opts = {},
    keys = {
      {
        "<leader>e",
        function()
          require("nvim-tree.api").tree.toggle()
        end,
      },
    },
  },
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
}
