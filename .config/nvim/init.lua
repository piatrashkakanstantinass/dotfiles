vim.opt.shiftwidth = 2

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      integrations = {
	mason = true
      }
    }
  },
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {},
  },

  -- LSP
  {
    "hrsh7th/nvim-cmp",
    version = false,
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    opts = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      return {
	snippet = {
	  expand = function(args)
	    luasnip.lsp_expand(args.body)
	  end
	},
	sources = cmp.config.sources({
	  { name = "nvim_lsp" },
	  { naem = "luasnip" },
	}),
      }
    end,
  },
  "hrsh7th/cmp-nvim-lsp",
  {
    "williamboman/mason.nvim",
    opts = {}
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp"
    },
    opts = {
      handlers = {
	function (server_name)
	  local capabilities = require("cmp_nvim_lsp").default_capabilities()
	  require("lspconfig")[server_name].setup({
	    capabilities = capabilities
	  })
	end
      }
    }
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
  },
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    opts = {

    }
  },
  "saadparwaiz1/cmp_luasnip",

}, {
  install = {
    colorscheme = { "catppuccin" }
  }
})

vim.cmd("colorscheme catppuccin")
