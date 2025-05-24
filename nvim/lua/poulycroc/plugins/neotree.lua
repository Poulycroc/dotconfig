return {
	{
		"nvim-tree/nvim-web-devicons",
		config = function()
			require("nvim-web-devicons").setup({
				strict = true,
				override_by_extension = {
					["blade.php"] = {
						icon = "",
						color = "#ff2d20",
						name = "blade",
					},
				},
			})
		end,
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("neo-tree").setup({
				filesystem = {
					follow_current_file = {
						enabled = true,
					},
					use_libuv_file_watcher = true,
					filtered_items = {
						visible = true,
						hide_by_name = {
							".DS_Store",
							"thumbs.db",
						},
						hide_by_pattern = {
							"*.meta",
							"*.lock",
							"*.log",
							"*.tmp",
							"node_modules/**",
							".git/**",
						},
						show_hidden_count = false,
						hide_dotfiles = false,
						hide_gitignored = false,
					},
				},
				close_if_last_window = false,
				window = {
					width = 30,
				},
				auto_close = true,
				default_component_configs = {
					icon = {
						folder_empty = "",
						folder_empty_open = "",
						folder_closed = "",
						folder_open = "",
					},
					name = {
						trailing_slash = false,
						use_git_status_colors = true,
					},
					git_status = {
						symbols = {
							-- Change type
							added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
							modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
							deleted = "✖", -- this can only appear on the left of the name and it should be red
							renamed = "➜", -- this can only appear on the left of the name and it should be yellow
							-- Status type
							untracked = "★", -- new file, not tracked yet
							ignored = "◌", -- (ignored file in nvim-tree)
							unstaged = "✗", -- file that is modified but uncommitted
							staged = "✓", -- file that is modified and tracked
							conflict = "", -- file with both staged and working changes
						},
					},
				},
			})
		end,

		vim.keymap.set("n", "<C-n>", ":Neotree toggle<CR>", { desc = "Toggle NeoTree" }),
		-- vim.keymap.set('n', '<C-t>', ':Neotree filesystem reveal left toggle<CR>', {}),
	},
}
