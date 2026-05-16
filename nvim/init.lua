require("poulycroc.config.options")
require("poulycroc.config.autocmds")
require("poulycroc.config.mason-verify")
require("poulycroc.config.health-check")

-- PLUGINS
vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim" },

	{ src = "https://github.com/folke/lazydev.nvim" },
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
	{ src = "https://github.com/ibhagwan/fzf-lua" },

	{ src = "https://github.com/tpope/vim-fugitive" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/kdheepak/lazygit.nvim" },
	{ src = "https://github.com/mbbill/undotree" },

	-- mini
	{ src = "https://github.com/nvim-mini/mini.statusline" },
	{ src = "https://github.com/nvim-mini/mini.surround" },
	{ src = "https://github.com/nvim-mini/mini.pairs" },
	{ src = "https://github.com/nvim-mini/mini.ai" },

	-- LSP
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
	},

	{ src = "https://github.com/numToStr/Comment.nvim" },
	{ src = "https://github.com/stevearc/conform.nvim" },

	-- folke
	{ src = "https://github.com/folke/flash.nvim" },
	{ src = "https://github.com/folke/todo-comments.nvim" },

	-- dap
	{ src = "https://github.com/rcarriga/nvim-dap-ui" },
	{ src = "https://github.com/theHamsta/nvim-dap-virtual-text" },
	{ src = "https://github.com/leoluz/nvim-dap-go" },
	{ src = "https://github.com/mfussenegger/nvim-dap.git" },

	{ src = "https://github.com/nvim-tree/nvim-tree.lua" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },

	{ src = "https://github.com/catppuccin/nvim" },

	-- ai
	{ src = "https://github.com/zbirenbaum/copilot.lua" },
	--{ src = "https://github.com/greggh/claude-code.nvim" },

	-- languages
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
	{ src = "https://github.com/nvim-neotest/nvim-nio" },
	-- { src = "https://github.com/adalessa/laravel.nvim" },

	-- test
	{ src = "https://github.com/nvim-neotest/neotest" },
	{ src = "https://github.com/marilari88/neotest-vitest" },
	{ src = "https://github.com/nvim-neotest/neotest-jest" },
	{ src = "https://github.com/olimorris/neotest-phpunit" },

	{ src = "https://github.com/cbochs/grapple.nvim" },

	-- tmux smart navigator
	{ src = "https://github.com/christoomey/vim-tmux-navigator" },
	-- { src = "https://github.com/mrjones2014/smart-splits.nvim" },

	-- markdown
	{ src = "https://github.com/iamcco/markdown-preview.nvim" },
})

-- require("poulycroc.plugins.smart-splits")

require("poulycroc.core.lsp")
require("poulycroc.core.mason")

require("poulycroc.plugins.blink")
require("poulycroc.plugins.fzf-lua")
require("poulycroc.plugins.conform")
require("poulycroc.plugins.dap")

require("poulycroc.plugins.comment")
require("poulycroc.plugins.folke")

require("poulycroc.plugins.nvim-tree")
require("poulycroc.plugins.nvim-web-devicons")
require("poulycroc.plugins.nvim-treesitter")

require("poulycroc.plugins.mini")
require("poulycroc.plugins.ai")
require("poulycroc.plugins.git")
-- require("poulycroc.plugins.languages")
require("poulycroc.plugins.terminal")

require("poulycroc.plugins.catppuccin")

require("poulycroc.config.keymaps")
