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
			["tab"] = "down",
			["shift-tab"] = "up",
		},
	},
	actions = {
		files = {
			["ctrl-q"] = require("fzf-lua.actions").file_sel_to_qf,
			["ctrl-n"] = require("fzf-lua.actions").toggle_ignore,
			["ctrl-h"] = require("fzf-lua.actions").toggle_hidden,
			["enter"] = require("fzf-lua.actions").file_edit_or_qf,
			["ctrl-o"] = function(selected, opts)
				local file = require("fzf-lua.path").entry_to_file(selected[1], opts)
				local path = file.path
				if not path:match("^/") then
					path = (opts and opts.cwd or vim.fn.getcwd()) .. "/" .. path
				end

				local width = math.floor(vim.o.columns * 0.8)
				local height = math.floor(vim.o.lines * 0.8)
				local win = vim.api.nvim_open_win(0, true, {
					relative = "editor",
					width = width,
					height = height,
					row = math.floor((vim.o.lines - height) / 2),
					col = math.floor((vim.o.columns - width) / 2),
					border = "rounded",
				})
				vim.cmd.edit(vim.fn.fnameescape(path))
				if file.line then
					pcall(vim.api.nvim_win_set_cursor, 0, { file.line, file.col or 0 })
				end

				local close = ("<cmd>%dclose<CR>"):format(win)
				vim.keymap.set("n", "q", close, { buffer = 0, nowait = true })
				vim.keymap.set("n", "<Esc>", close, { buffer = 0, nowait = true })
			end,
		},
	},
})
