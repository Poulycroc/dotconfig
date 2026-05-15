local dap = require('dap')
local map = vim.keymap.set

dap.adapters.debugpy = function(cb, config) -- also $ uv tool install debugpy@latest
	if config.request == 'attach' then
		cb({
			type = 'server',
			port = config.connect.port,
			host = config.connect.host or '127.0.0.1',
		})
	else
		cb({
			type = 'executable',
			command = 'debugpy-adapter',
		})
	end
end

dap.configurations.python = { -- https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings
	{
		type = 'debugpy',
		request = 'launch',
		name = 'Launch file',
		program = '${file}',
		python = function()
			local root = vim.fs.root(0, '.venv')
			return { root and root .. '/.venv/bin/python' or 'python3' }
		end,
		cwd = function()
			return vim.fs.root(0, '.venv') or vim.fn.getcwd()
		end,
	},
}

map('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug toggle breakpoint' })
map('n', '<leader>dc', dap.continue, { desc = 'Debug continue' })
map('n', '<leader>dq', dap.terminate, { desc = 'Debug terminate' })
map('n', '<leader>dr', dap.repl.open, { desc = 'Debug open REPL' })
map('n', '<leader>dl', dap.run_last, { desc = 'Debug run last' })
map({ 'n', 'v' }, '<leader>dh', require('dap.ui.widgets').hover, { desc = 'Debug hover' })
map('n', '<Down>', dap.step_over, { desc = 'Debug step over' })
map('n', '<Right>', dap.step_into, { desc = 'Debug step into' })
map('n', '<Left>', dap.step_out, { desc = 'Debug step out' })
map('n', '<Up>', dap.restart_frame, { desc = 'Debug restart frame' })
