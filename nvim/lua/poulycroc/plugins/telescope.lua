-- telescope.nvim
return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
			},
		},
		config = function()
			require("telescope").setup({
				defaults = {
					sorting_strategy = "ascending",
					layout_strategy = "horizontal",
					layout_config = {
						horizontal = {
							prompt_position = "top",
							preview_width = 0.55,
							results_width = 0.8,
						},
						vertical = {
							mirror = false,
						},
					},
				},
				extensions = {
					fzf = {
						fuzzy = true, -- false will only do exact matching
						override_generic_sorter = true, -- override the generic sorter
						override_file_sorter = true, -- override the file sorter
						case_mode = "smart_case",
					},
				},
				pickers = {
					colorscheme = {
						enable_preview = true,
					},
					find_files = {
						hidden = true,
						find_command = {
							"rg",
							"--files",
							"--glob",
							"!{.git/*,.next/*,.svelte-kit/*,target/*,node_modules/*}",
							"--path-separator",
							"/",
						},
					},
				},
			})

			require("telescope").load_extension("fzf")
			require("telescope").load_extension("zoxide")
			-- telescope setup

			local map = vim.keymap.set
			local builtin = require("telescope.builtin")

			map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Telescope Find files" })
			map("n", "<leader>ds", builtin.lsp_document_symbols, { desc = "Telescope LSP Document symbols" })
			map("n", "<leader>ws", builtin.lsp_workspace_symbols, { desc = "Telescope LSP Workspace symbols" })
			map("n", "<leader>fz", ":Telescope zoxide list<CR>", {})
			map("n", "<leader>fw", builtin.live_grep, { desc = "Telescope Live grep" })
			map("n", "<leader>fd", builtin.diagnostics, { desc = "Telescope LSP Diagnostics" })
			map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Telescope Find buffers" })

			map("n", "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "Telescope Git status" })
			map("n", "<leader>th", "<cmd>Telescope themes<CR>", { desc = "Telescope Nvchad themes" })
		end,
	},
	{
		"jvgrootveld/telescope-zoxide",
		config = function() end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({
							-- even more opts
						}),
					},
				},
			})
			-- To get ui-select loaded and working with telescope, you need to call
			-- load_extension, somewhere after setup function:
			require("telescope").load_extension("ui-select")
		end,
	},
}
