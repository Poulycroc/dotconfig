require("neotest").setup({
	adapters = {
		--require("neotest-python")({
		--	dap = { justMyCode = false },
		--}),
		--require("neotest-plenary"),
		--require("neotest-vim-test")({
		--	ignore_file_types = { "python", "vim", "lua" },
		--}),
		require("neotest-vitest"),
		require("neotest-jest"),
		require("neotest-phpunit"),
	},
})
