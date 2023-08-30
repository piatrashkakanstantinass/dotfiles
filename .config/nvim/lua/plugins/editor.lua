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
}
