require("poulycroc.config.options")
require("poulycroc.config.autocmds")

-- Plugins
-- Pack guide: https://echasnovski.com/blog/2026-03-13-a-guide-to-vim-pack#update
vim.pack.add({
	'https://github.com/folke/lazydev.nvim',

	'https://github.com/ibhagwan/fzf-lua',
	"https://github.com/nvim-tree/nvim-tree.lua",
	"https://github.com/nvim-tree/nvim-web-devicons",
	'https://github.com/cbochs/grapple.nvim',

	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/kdheepak/lazygit.nvim" },
	{ src = "https://github.com/mbbill/undotree" },

	-- folke
	"https://github.com/folke/flash.nvim",
	"https://github.com/folke/todo-comments.nvim",
	"https://github.com/numToStr/Comment.nvim",

	'https://github.com/MeanderingProgrammer/render-markdown.nvim',

	"https://github.com/nvim-neotest/neotest",
	'https://github.com/mfussenegger/nvim-dap',
	{ src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1.x') }, -- pinning so rust binary dependency automatically downloads

	{ src = "https://github.com/catppuccin/nvim" },
})

-- Plugins setups
require("poulycroc.plugins.nvim-tree")
require("poulycroc.plugins.nvim-web-devicons")

require('render-markdown').setup({})
require("poulycroc.plugins.dap")
require("poulycroc.plugins.comment")
require("poulycroc.plugins.folke")
require('poulycroc.plugins.fzf-lua')
require('poulycroc.plugins.blink')

require("poulycroc.plugins.catppuccin")

require("poulycroc.config.keymaps")
