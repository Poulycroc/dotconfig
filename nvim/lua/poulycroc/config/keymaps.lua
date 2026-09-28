local map = vim.keymap.set

--  See `:help vim.keymap.set()`

-- Disable Space bar since it will be used as the leader key
vim.keymap.set({ "n", "v" }, "<leader>", "<nop>", { desc = "Disable leader key default" })

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

-- Fzf
map("n", "<leader>ff", "<cmd>FzfLua files<CR>")
map("n", "<leader>fb", "<cmd>FzfLua buffers<CR>")
map("n", "<leader>fw", "<cmd>FzfLua live_grep<CR>")
map("n", "<leader>fh", "<cmd>FzfLua neovim help<CR>")

-- Grapple
map("n", "<leader>fl", "<cmd>Grapple toggle_tags<cr>", { desc = "Toggle tags menu" })

map("n", "gR", "<cmd>FzfLua lsp_implementations<CR>")
map("n", "gd", "<cmd>FzfLua lsp_definitions<CR>")
map("n", "gD", "<cmd>FzfLua lsp_declarations<CR>")

-- GIT
map("n", "<leader>lg", "<cmd>LazyGit<cr>", { desc = "Open lazy git" })
map("n", "<leader>gl", "<cmd>LazyGitLog<cr>", { desc = "Open lazy git log" })
map("n", "<leader>cd", "<cmd>CodeDiff<cr>", { desc = "CodeDiff explorer" })
map("n", "<leader>cD", "<cmd>CodeDiff file HEAD<cr>", { desc = "CodeDiff current file vs HEAD" })
map("n", "<leader>ch", "<cmd>CodeDiff history<cr>", { desc = "CodeDiff history" })
map("n", "<leader>gs", "<cmd>Git<CR>", { desc = "Git fugitive" })
map("n", "<leader>gp", "<cmd>Git push<CR>", { desc = "Git push fugitive" })
map("n", "<leader>GU", ":UndotreeToggle<CR>", { desc = "Toggle UndoTree" })

map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "toggle file explorer" })

-- Comment
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

-- Command-line completion
map("c", "<C-j>", "<C-n>", { desc = "Next command-line completion" })
map("c", "<C-k>", "<C-p>", { desc = "Previous command-line completion" })
