--------------
-- obsidian --
--------------
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
		if not name or name == "" then return end
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
