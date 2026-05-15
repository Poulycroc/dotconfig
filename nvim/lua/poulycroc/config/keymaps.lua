local map = vim.keymap.set

--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
map("n", "<leader>nh", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

map("v", "J", ":m '>+1<CR>gv=gv", { desc = "moves lines down in visual selection" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "moves lines up in visual selection" })

-- Move in lines
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll Down + auto center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll Up + auto center" })
map("n", "n", "nzzzv", { desc = "Next search result + auto center" })
map("n", "N", "Nzzzv", { desc = "Previous search result + auto center" })

map("v", "<", "<gv", { noremap = true, silent = true, desc = "Decrease indent in visual selection" })
map("v", ">", ">gv", { noremap = true, silent = true, desc = "Increase indent in visual selection" })

map("n", "Q", "<nop>", { noremap = true, silent = true, desc = "Disable Q" })
map("n", "f", "<nop>", { noremap = true, silent = true, desc = "Disable f" })
map("n", "x", '"_x', { desc = "Delete without yank" })

-- GIT
map("n", "<leader>lg", "<cmd>LazyGit<cr>", { desc = "Open lazy git" })
map("n", "<leader>gl", "<cmd>LazyGitLog<cr>", { desc = "Open lazy git log" })
map("n", "<leader>gs", "<cmd>Git<CR>", { desc = "Git fugitive" })
map("n", "<leader>gp", "<cmd>Git push<CR>", { desc = "Git push fugitive" })
map("n", "<leader>GU", ":UndotreeToggle<CR>", { desc = "Toggle UndoTree" })

-- TreeToggle
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "toggle file explorer" })

-- comment
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

-- test command
map("n", "<leader>tr", "<cmd>Neotest run<cr>", { desc = "Neotest: run" })
map("n", "<leader>ti", "<cmd>Neotest output<cr>", { desc = "Neotest: output" })
map("n", "<leader>ts", "<cmd>Neotest summary<cr>", { desc = "Neo: summary" })

-- Grapple
map("n", "<leader>m", "<cmd>Grapple toggle<cr>", { desc = "Grapple toggle tag" })
map("n", "<leader>M", "<cmd>Grapple toggle_tags<cr>", { desc = "Grapple open tags window" })
map("n", "<tab>", "<cmd>Grapple cycle_tags next<cr>", { desc = "Grapple cycle next tag" })
map("n", "<S-tab>", "<cmd>Grapple cycle_tags prev<cr>", { desc = "Grapple cycle previous tag" })

