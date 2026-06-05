--------------
-- obsidian --
--------------
--
-- this workflow is ispired by https://github.com/zazencodes
-- the idea is to have a workflow for quickly capturing notes in the inbox, then reviewing them at the end of the day/week and moving them to the zettelkasten or deleting them
--
-- >>> oo # from shell, navigate to vault (optional)
--
-- # NEW NOTE
-- >>> on "Note Name" # call my "obsidian new note" shell script (~/bin/on)
-- >>>
-- >>> ))) <leader>on # inside vim, format note as template
-- >>> ))) # add tag, e.g. fact / blog / video / etc..
-- >>> ))) # add hubs, e.g. [[python]], [[machine-learning]], etc...
-- >>> ))) <leader>of # format title
--
-- # END OF DAY/WEEK REVIEW
-- >>> or # review notes in inbox
-- >>>
-- >>> ))) <leader>ok # inside vim now, move to zettelkasten
-- >>> ))) <leader>odd # or delete
-- >>>
-- >>> og # organize saved notes from zettelkasten into notes/[tag] folders
-- >>> ou # sync local with Notion
--
-- create new note in inbox with template (prompts for name)
vim.keymap.set("n", "<leader>on", function()
	vim.ui.input({ prompt = "Note name: " }, function(name)
		if not name or name == "" then
			return
		end
		vim.cmd("ObsidianNew " .. name)
		vim.defer_fn(function()
			vim.cmd("ObsidianTemplate note")
		end, 100)
	end)
end)

-- organize notes from zettelkasten into notes/[tag] folders
vim.keymap.set("n", "<leader>og", ":!~/.config/bin/og.sh<cr>")

-- strip date from note title and replace dashes with spaces
-- must have cursor on title
vim.keymap.set("n", "<leader>of", ":s/\\(# \\)[^_]*_/\\1/ | s/-/ /g<cr>")
--
-- search for files in full vault
vim.keymap.set("n", "<leader>oi", ':FzfLua files cwd="/Users/poulycroc/PoulyStuff/index"<cr>')
vim.keymap.set("n", "<leader>os", ':FzfLua files cwd="/Users/poulycroc/PoulyStuff/notes"<cr>')
vim.keymap.set("n", "<leader>oz", ':FzfLua live_grep cwd="/Users/poulycroc/PoulyStuff/notes"<cr>')
--
-- search for files in notes (ignore zettelkasten)
-- vim.keymap.set("n", "<leader>ois", ":Telescope find_files search_dirs={\"/Users/alex/library/Mobile\\ Documents/iCloud~md~obsidian/Documents/ZazenCodes/notes\"}<cr>")
-- vim.keymap.set("n", "<leader>oiz", ":Telescope live_grep search_dirs={\"/Users/alex/library/Mobile\\ Documents/iCloud~md~obsidian/Documents/ZazenCodes/notes\"}<cr>")
--
-- for review workflow
-- move file in current buffer to zettelkasten folder
vim.keymap.set("n", "<leader>ok", ":!mv '%:p' /Users/poulycroc/PoulyStuff/zettelkasten<cr>:bd<cr>")
-- delete file in current buffer
vim.keymap.set("n", "<leader>odd", ":!rm '%:p'<cr>:bd<cr>")

--------------
-- journal --
--------------
--
-- plain text journaling inspired by https://oppi.li/posts/plain_text_journaling/
-- daily capture with bullet-journal signifiers, monthly consolidation
-- signifiers: · (todo), × (done), - (note), o (event), > (moved)
--
-- >>> jt  # from shell, open/create today's journal
-- >>> jy  # from shell, open yesterday's journal
-- >>> jc  # from shell, consolidate current month
--
-- >>> ))) <leader>ojt  # inside vim, open today's journal
-- >>> ))) <leader>ojy  # inside vim, open yesterday's journal
-- >>> ))) <leader>ojc  # inside vim, consolidate current month
-- >>> ))) <leader>ojs  # inside vim, search journal entries
-- >>> ))) <leader>ojm  # inside vim, open current month's consolidated file

-- open/create today's journal
vim.keymap.set("n", "<leader>ojt", function()
	local path = vim.fn.system("~/.config/bin/jt.sh"):gsub("%s+$", "")
	vim.cmd("edit " .. path)
end)

-- open yesterday's journal
vim.keymap.set("n", "<leader>ojy", function()
	local path = vim.fn.system("~/.config/bin/jy.sh"):gsub("%s+$", "")
	vim.cmd("edit " .. path)
end)

-- consolidate current month
vim.keymap.set("n", "<leader>ojc", ":!~/.config/bin/jc.sh<cr>")

-- search journal entries
vim.keymap.set("n", "<leader>ojs", ':FzfLua live_grep cwd="/Users/poulycroc/PoulyStuff/journal"<cr>')

-- open current month's consolidated file
vim.keymap.set("n", "<leader>ojm", function()
	local month_file = "/Users/poulycroc/PoulyStuff/journal/"
		.. os.date("%Y")
		.. "/"
		.. os.date("%m")
		.. ".md"
	if vim.fn.filereadable(month_file) == 1 then
		vim.cmd("edit " .. month_file)
	else
		vim.notify("No consolidated file yet for this month", vim.log.levels.WARN)
	end
end)

-- journal autocommands: signifiers, sorting, syntax highlighting
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*/journal/*",
	callback = function()
		-- abbreviations for signifiers
		vim.cmd("iabbrev <buffer> todo ·")
		vim.cmd("iabbrev <buffer> done ×")

		-- sort with gqip
		vim.opt_local.formatprg = "sort -V"

		-- syntax highlighting for signifiers
		vim.cmd("syntax match JournalTodo /^·.*/")
		vim.cmd("syntax match JournalDone /^×.*/")
		vim.cmd("syntax match JournalEvent /^o .*/")
		vim.cmd("syntax match JournalNote /^- .*/")
		vim.cmd("syntax match JournalMoved /^>.*/")

		vim.cmd("highlight JournalTodo ctermfg=White guifg=#ffffff")
		vim.cmd("highlight JournalDone ctermfg=Grey guifg=#666666")
		vim.cmd("highlight JournalEvent ctermfg=Cyan guifg=#00cccc")
		vim.cmd("highlight JournalNote ctermfg=Yellow guifg=#cccc00")
		vim.cmd("highlight JournalMoved ctermfg=Magenta guifg=#cc00cc")
	end,
})
