return {
	"akinsho/toggleterm.nvim",
	version = "*",
	opts = function()
		local map = vim.keymap.set -- for conciseness

		map("n", "<leader>tt", "<cmd>lua require('toggleterm').toggle()<CR>", {
			desc = "Toggle terminal",
			noremap = true,
			silent = true,
		})
	end,
}

