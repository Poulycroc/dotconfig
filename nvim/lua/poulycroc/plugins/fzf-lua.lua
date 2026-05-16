require("fzf-lua").setup({
	winopts = { backdrop = 85 },
	file_ignore_patterns = {
		"node_modules/",
		"vendor/",
		"dist/",
		".next/",
		".git/",
		".gitlab/",
		"build/",
		"target/",
		"package-lock.json",
		"pnpm-lock.yaml",
		"yarn.lock",
	},
	keymap = {
		builtin = {
			["<C-f>"] = "preview-page-down",
			["<C-b>"] = "preview-page-up",
			["<C-p>"] = "toggle-preview",
		},
		fzf = {
			["ctrl-a"] = "toggle-all",
			["ctrl-t"] = "first",
			["ctrl-g"] = "last",
			["ctrl-d"] = "half-page-down",
			["ctrl-u"] = "half-page-up",
		},
	},
	actions = {
		files = {
			["ctrl-q"] = require("fzf-lua.actions").file_sel_to_qf,
			["ctrl-n"] = require("fzf-lua.actions").toggle_ignore,
			["ctrl-h"] = require("fzf-lua.actions").toggle_hidden,
			["enter"] = require("fzf-lua.actions").file_edit_or_qf,
		},
	},
})
