vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
	callback = function()
		vim.opt.number = false
		vim.opt.relativenumber = false
	end,
})

vim.keymap.set("n", "<leader>st", function()
	vim.cmd.vnew()
	vim.cmd.term()
	vim.cmd.wincmd("J")
	vim.api.nvim_win_set_height(0, 10)
end)

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true })

-- ordna todo list in centered float (lazygit-style)
vim.keymap.set("n", "<leader>to", function()
	local buf = vim.api.nvim_create_buf(false, true)
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		col = math.floor((vim.o.columns - width) / 2),
		row = math.floor((vim.o.lines - height) / 2),
		style = "minimal",
		border = "rounded",
	})
	vim.fn.jobstart("ordna", {
		term = true,
		on_exit = function()
			if vim.api.nvim_win_is_valid(win) then
				vim.api.nvim_win_close(win, true)
			end
		end,
	})
	vim.cmd.startinsert()
end, { desc = "Todo list (ordna)" })
