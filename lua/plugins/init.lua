return {
  {
    "stevearc/conform.nvim",
    event = 'BufWritePre', -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },

  {
    "edluffy/hologram.nvim",
  },

  {
    'MeanderingProgrammer/dashboard.nvim',
    event = 'VimEnter',
    dependencies = {
      { 'MaximilianLloyd/ascii.nvim', dependencies = { 'MunifTanjim/nui.nvim' } },
    },
    config = function()
      require('dashboard').setup({
        header = require('ascii').art.text.doom.DooM,
          date_format = '%Y-%m-%d %H:%M:%S',
          directories = {
            '~/.config',
            '~/Documents/notes',
          },
      })
    end,
  }
  -- These are some examples, uncomment them if you want to see them work!
  -- {
  --   "neovim/nvim-lspconfig",
  --   config = function()
  --     require("nvchad.configs.lspconfig").defaults()
  --     require "configs.lspconfig"
  --   end,
  -- },
  --
  -- {
  -- 	"williamboman/mason.nvim",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"lua-language-server", "stylua",
  -- 			"html-lsp", "css-lsp" , "prettier"
  -- 		},
  -- 	},
  -- },
  --
  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
