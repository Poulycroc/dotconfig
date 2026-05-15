local map = vim.keymap.set
local flash_loaded = false

local function flash()
	local ok, mod = pcall(require, "flash")
	if not ok then
		return nil
	end
	if not flash_loaded then
		mod.setup({}) -- your opts = {}
		map({ "n", "x", "o" }, "f", "<nop>", { noremap = true, silent = true, desc = "Disable f" })
		flash_loaded = true
	end
	return mod
end

-- Keymaps that load flash on first use
map({ "n", "x", "o" }, "zk", function()
	local m = flash()
	if m then
		m.jump()
	end
end, { desc = "Flash" })

map({ "n", "x", "o" }, "Zk", function()
	local m = flash()
	if m then
		m.treesitter()
	end
end, { desc = "Flash Treesitter" })

map("o", "r", function()
	local m = flash()
	if m then
		m.remote()
	end
end, { desc = "Remote Flash" })

map({ "o", "x" }, "R", function()
	local m = flash()
	if m then
		m.treesitter_search()
	end
end, { desc = "Treesitter Search" })

map("c", "<C-s>", function()
	local m = flash()
	if m then
		m.toggle()
	end
end, { desc = "Toggle Flash Search" })

require("todo-comments").setup({ signs = false })
