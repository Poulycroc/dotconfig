local dap = require("dap")
local dapui = require("dapui")

-- optional
-- require('mason-nvim-dap').setup {
--     automatic_installation = true,
--     handlers = {},
--     ensure_installed = {
--         'delve',
--     },
-- }

-- Dap UI setup
dapui.setup({
	icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
	controls = {
		icons = {
			pause = "⏸",
			play = "▶",
			step_into = "⏎",
			step_over = "⏭",
			step_out = "⏮",
			step_back = "b",
			run_last = "▶▶",
			terminate = "⏹",
			disconnect = "⏏",
		},
	},
})

-- Automatically open/close DAP UI
dap.listeners.after.event_initialized["dapui_config"] = dapui.open
dap.listeners.before.event_terminated["dapui_config"] = dapui.close
dap.listeners.before.event_exited["dapui_config"] = dapui.close

-- Setup virtual text to show variable values inline
require("nvim-dap-virtual-text").setup()

require("dap-go").setup({
	delve = {
		-- Use Mason's delve installation with fallback to system delve
		path = function()
			local mason_delve = vim.fn.stdpath("data") .. "/mason/bin/dlv"
			if vim.fn.executable(mason_delve) == 1 then
				return mason_delve
			end
			-- Fallback to system delve
			return vim.fn.exepath("dlv") ~= "" and vim.fn.exepath("dlv") or "dlv"
		end,

		-- On Windows delve must be run attached or it crashes.
		-- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
		-- detached = vim.fn.has 'win32' == 0,
	},
})
