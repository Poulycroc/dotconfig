return {
	"tiagovla/scope.nvim",
	config = function()
		local map = vim.keymap.set

		map("n", "<tab>", "<cmd>bnext<CR>", { desc = "Buffer Next" })
		map("n", "<S-tab>", "<cmd>bprev<CR>", { desc = "Buffer Prev" })
	end,
}

