local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

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

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- auto close brackets
-- this
autocmd("FileType", {
	pattern = "man",
	command = [[nnoremap <buffer><silent> q :quit<CR>]],
})

autocmd("FileType", {
	callback = function()
		pcall(vim.treesitter.start)
	end,
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
