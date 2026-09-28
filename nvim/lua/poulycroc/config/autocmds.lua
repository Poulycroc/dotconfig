local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  change from `:help vim.hl.on_yank()` to `vim.hl.hl_op()` see https://neovim.io/doc/user/deprecated/
autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.hl_op()
	end,
})

-- auto close brackets
-- this
autocmd("FileType", {
	pattern = "man",
	command = [[nnoremap <buffer><silent> q :quit<CR>]],
})

autocmd("FileType", {
	group = augroup("UserConfig", { clear = true }),
	pattern = { "markdown", "text", "gitcommit" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.spell = true
	end,
})

-- don't auto comment new line
autocmd("BufEnter", {
	command = [[set formatoptions-=cro]],
})

-- wrap words "softly" (no carriage return) in mail buffer
autocmd("Filetype", {
	pattern = "mail",
	callback = function()
		vim.opt.textwidth = 0
		vim.opt.wrapmargin = 0
		vim.opt.wrap = true
		vim.opt.linebreak = true
		vim.opt.columns = 80
		vim.opt.colorcolumn = "80"
	end,
})

-- syntax highlighting for dotenv files
autocmd("BufRead", {
	group = vim.api.nvim_create_augroup("dotenv_ft", { clear = true }),
	pattern = { ".env", ".env.*" },
	callback = function()
		vim.bo.filetype = "dosini"
	end,
})

-- auto resize splits when the terminal's window is resized
autocmd("VimResized", {
	command = "wincmd =",
})

-- remove plugins from disk that are no longer in vim.pack.add() specs
vim.api.nvim_create_user_command("PackClean", function()
	local inactive = vim.iter(vim.pack.get())
		:filter(function(x)
			return not x.active
		end)
		:map(function(x)
			return x.spec.name
		end)
		:totable()
	if #inactive == 0 then
		vim.notify("No inactive plugins to remove", vim.log.levels.INFO)
		return
	end
	vim.pack.del(inactive)
	vim.notify("Removed: " .. table.concat(inactive, ", "), vim.log.levels.INFO)
end, { desc = "Remove plugins not in vim.pack.add() specs" })
