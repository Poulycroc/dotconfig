require("obsidian").setup({
	legacy_commands = false,
	workspaces = {
		{
			name = "PoulyStuff",
			path = "/Users/poulycroc/PoulyStuff",
		},
	},
	notes_subdir = "inbox",
	new_notes_location = "notes_subdir",

	frontmatter = { enabled = false },
	templates = {
		folder = "templates",
		date_format = "%Y-%m-%d",
		time_format = "%H:%M:%S",
	},

	-- name new notes starting the ISO datetime and ending with note name
	-- put them in the inbox subdir
	-- note_id_func = function(title)
	--   local suffix = ""
	--   -- get current ISO datetime with -5 hour offset from UTC for EST
	--   local current_datetime = os.date("!%Y-%m-%d-%H%M%S", os.time() - 5*3600)
	--   if title ~= nil then
	--     suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
	--   else
	--     for _ = 1, 4 do
	--       suffix = suffix .. string.char(math.random(65, 90))
	--     end
	--   end
	--   return current_datetime .. "_" .. suffix
	-- end,

	-- completion comes from the built-in obsidian-ls LSP server, blink picks it up via its lsp source
	ui = { enable = false },
})

-- <CR> (smart action) follows links and toggles checkboxes by default
vim.keymap.set("n", "<leader>ti", "<cmd>Obsidian toggle_checkbox<cr>", { desc = "Toggle checkbox" })
