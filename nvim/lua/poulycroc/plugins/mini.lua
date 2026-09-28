-- enhanced, a and i keybinds
require("mini.ai").setup()

-- auto pairs
require("mini.pairs").setup()

-- access to surround keymaps sa,sd,sc etc
require("mini.surround").setup()

-- git diff
require("mini.diff").setup({
	view = {
		style = "sign",
		signs = { add = "┃", change = "┃", delete = "┃" },
	},
})

local statusline = require("mini.statusline")
statusline.setup({ use_icons = vim.g.have_nerd_font })

---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function()
	return "%2l:%-2v"
end
