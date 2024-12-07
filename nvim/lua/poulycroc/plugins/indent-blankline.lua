return {
	"lukas-reineke/indent-blankline.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		indent = { char = "│" },
		scope = { char = "│" },
	},
	main = "ibl",
}
