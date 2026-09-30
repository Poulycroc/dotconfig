vim.pack.add({
	-- lazygit.nvim, todo-comments search
	"https://github.com/nvim-lua/plenary.nvim",

	-- File navigation
	"https://github.com/nvim-tree/nvim-tree.lua",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/ibhagwan/fzf-lua",
	"https://github.com/cbochs/grapple.nvim",

	-- Mini
	"https://github.com/nvim-mini/mini.statusline",
	"https://github.com/nvim-mini/mini.surround",
	"https://github.com/nvim-mini/mini.diff",
	"https://github.com/nvim-mini/mini.pairs",
	"https://github.com/nvim-mini/mini.ai",

	-- GIT
	"https://github.com/kdheepak/lazygit.nvim",
	"https://github.com/tpope/vim-fugitive",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/mbbill/undotree",
	"https://github.com/esmuellert/codediff.nvim",

	-- folke
	"https://github.com/folke/flash.nvim",
	"https://github.com/folke/todo-comments.nvim",

	-- Appearance
	"https://github.com/catppuccin/nvim",
	"https://github.com/mawkler/modicator.nvim",

	-- Completion, LSP, Format
	{
		src = "https://github.com/saghen/blink.cmp",
		version = vim.version.range("^1"),
	},
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		version = "main",
	},
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/b0o/SchemaStore.nvim",

	"https://github.com/rachartier/tiny-inline-diagnostic.nvim",

	-- AI
	"https://github.com/zbirenbaum/copilot.lua",

	-- tmux smart navigator
	"https://github.com/christoomey/vim-tmux-navigator",

	-- markdown
	"https://github.com/iamcco/markdown-preview.nvim",

	-- obsidian
	"https://github.com/obsidian-nvim/obsidian.nvim",
})

-- File navigation
require("poulycroc.plugins.nvim-tree")
require("poulycroc.plugins.nvim-web-devicons")
require("poulycroc.plugins.fzf-lua")

-- Mini
require("poulycroc.plugins.mini")

-- Git
require("poulycroc.plugins.git")

-- Folke
require("poulycroc.plugins.folke")

-- Appearance
require("modicator").setup()
require("poulycroc.plugins.catppuccin")

-- Completion, LSP, Format
require("poulycroc.plugins.treesitter")
require("poulycroc.plugins.blink")
require("poulycroc.plugins.formatting")
require("poulycroc.plugins.diagnostic")

-- AI
require("poulycroc.plugins.copilot")

require("poulycroc.plugins.obsidian")

require("poulycroc.plugins.tasker").setup()
