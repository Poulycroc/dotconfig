local fzf = require('fzf-lua')
local map = vim.keymap.set

fzf.setup({
	ui_select = true,
	keymap = {
		builtin = {
			["<C-d>"] = 'preview-page-down', -- Better scrolling within the displays
			["<C-u>"] = 'preview-page-up',
		},
	},
	winopts = { backdrop = 85 },
	files = {
		formatter = 'path.filename_first',
	},
})

map('n', '<leader>ff', '<cmd>FzfLua files<cr>', { desc = 'Find files' })
map('n', '<leader>fw', '<cmd>FzfLua live_grep<cr>', { desc = 'Find live grep' })
map('n', '<leader>fr', '<cmd>FzfLua resume<cr>', { desc = 'Resume last picker' })
map('n', '<leader>fb', '<cmd>FzfLua buffers<cr>', { desc = 'Buffers' })

map('n', 'grr', fzf.lsp_references, { desc = 'References' })
map('n', 'gri', fzf.lsp_implementations, { desc = 'Implementations' })
map('n', 'gra', fzf.lsp_code_actions, { desc = 'Code actions' })
map('n', 'gd', fzf.lsp_definitions, { desc = 'Go to definition' })
