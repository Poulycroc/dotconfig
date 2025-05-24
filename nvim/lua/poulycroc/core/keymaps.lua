vim.g.mapleader = " "

local map = vim.keymap.set -- for conciseness
local opts = { noremap = true, silent = true }

-- Windows navigation
map("n", "<C-h>", "<C-w>h", vim.tbl_extend("force", opts, { desc = "Go to left window" }))
map("n", "<C-j>", "<C-w>j", vim.tbl_extend("force", opts, { desc = "Go to bottom window" }))
map("n", "<C-k>", "<C-w>k", vim.tbl_extend("force", opts, { desc = "Go to top window" }))
map("n", "<C-l>", "<C-w>l", vim.tbl_extend("force", opts, { desc = "Go to right window" }))

-- increment/decrement numbers
map("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
map("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

map("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

map("n", "<tab>", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
map("n", "<S-tab>", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab

map("v", "J", ":m '>+1<CR>gv=gv", { desc = "moves lines down in visual selection" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "moves lines up in visual selection" })

-- Comment
map("n", "<leader>/", function()
  require("Comment.api").toggle.linewise.current()
end, { desc = "Comment Toggle" })

map(
  "v",
  "<leader>/",
  "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
  { desc = "Comment Toggle" }
)

-- Move in lines
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll Down + auto center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll Up + auto center" })
map("n", "n", "nzzzv", { desc = "Next search result + auto center" })
map("n", "N", "Nzzzv", { desc = "Previous search result + auto center" })

map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

map("n", "Q", "<nop>", { desc = "Disable Q" })
map("n", "x", '"_x', { desc = "Delete without yank" })

-- Replace the word cursor is on globally
map(
  "n",
  "<leader>s",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Replace word cursor is on globally" }
)

-- Executes shell command from in here making file executable
map("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "makes file executable" })

-- Hightlight yanking
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})