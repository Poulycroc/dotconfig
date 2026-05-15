vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

local function my_on_attach(bufnr)
	local api = require "nvim-tree.api"

	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	-- default mappings
	api.config.mappings.default_on_attach(bufnr)
end

require("nvim-tree").setup({
	on_attach = my_on_attach,
	view = {
		width = 40,
		relativenumber = false,
	},
	sync_root_with_cwd = true,
	respect_buf_cwd = true,
	update_focused_file = {
		enable = true, -- sync current file with tree
		update_root = {
			enable = true,
		},
	},
	renderer = {
		highlight_opened_files = "none", -- disable the “visited files” highlight
		indent_markers = {
			enable = true,
		},
		icons = {
			glyphs = {
				folder = {
					arrow_closed = "-",
					arrow_open = "*",
				},
			},
		},
	},
	actions = {
		open_file = {
			window_picker = {
				enable = true,
			},
		},
	},
	filters = {
		custom = { ".DS_Store" },
	},
	git = {
		ignore = false,
	},
})

-- Follow only the *current* buffer in nvim-tree
local api = require("nvim-tree.api")

vim.api.nvim_create_autocmd({ "BufEnter", "TabEnter" }, {
	callback = function(args)
		-- ignore the tree buffer itself
		if vim.bo[args.buf].filetype == "NvimTree" then return end
		-- do nothing if the tree isn't visible
		if not api.tree.is_visible() then return end
		-- move the tree selection to the current buffer's file
		api.tree.find_file({
			buf   = args.buf,  -- current buffer
			open  = false,     -- don't open the tree if it's closed
			focus = false,     -- don't steal focus from your code window
			-- update_root = false, -- leave root alone; set true if you want root to follow
		})
	end,
})

vim.cmd([[
    :hi      NvimTreeExecFile    guifg=#ffa0a0
    :hi      NvimTreeSpecialFile guifg=#ff80ff gui=underline
    :hi      NvimTreeSymlink     guifg=Yellow  gui=italic
    :hi link NvimTreeImageFile   Title
		:hi NvimTreeCursorLine guibg=#3b4252 guifg=#88c0d0
]])
