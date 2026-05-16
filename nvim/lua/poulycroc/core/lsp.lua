vim.lsp.enable({
	"bashls",
	"gopls",
	"lua_ls",
	"texlab",
	"ts_ls",
	"rust-analyzer",
	"helm_ls",
	"zls",
	"intelephense",
	"tailwindcss",
	"html-ls",
	"css-ls",
	-- vue_ls started manually after ts_ls attaches (Volar v2 requires ts_ls to be present first)
	"pug-ls",
	"json-ls",
	"yaml-ls",
})

-- Start vue_ls only after ts_ls has attached to a Vue buffer (fixes "Could not find ts_ls" error)
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client.name == "ts_ls" and vim.bo[args.buf].filetype == "vue" then
			if #vim.lsp.get_clients({ bufnr = args.buf, name = "vue_ls" }) == 0 then
				vim.schedule(function()
					local ok, config = pcall(dofile, vim.fn.stdpath("config") .. "/lsp/vue_ls.lua")
					if ok and type(config) == "table" then
						config.name = "vue_ls"
						vim.lsp.start(config, { bufnr = args.buf })
					end
				end)
			end
		end
	end,
})

-- Smart filter for "unused variable" diagnostics in Vue files with Pug templates
-- Only filters if the variable IS actually used in the Pug template
local function is_var_used_in_pug_template(bufnr, var_name)
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	local content = table.concat(lines, "\n")

	-- Check if this is a Pug template
	if not content:match('<template[^>]*lang="pug"') then
		return false -- Not a Pug template, don't filter
	end

	-- Extract template section
	local template_start = content:find('<template[^>]*lang="pug"[^>]*>')
	local template_end = content:find('</template>')
	if not template_start or not template_end then
		return false
	end

	local template_content = content:sub(template_start, template_end)

	-- Check if variable is used in template (various patterns)
	local patterns = {
		'{{%s*' .. var_name .. '[%s%.]',           -- {{ varName or {{ varName.
		'{{%s*' .. var_name .. '%s*}}',            -- {{ varName }}
		'v%-if="[^"]*' .. var_name,                -- v-if="varName" or v-if="!varName"
		'v%-else%-if="[^"]*' .. var_name,          -- v-else-if
		'v%-show="[^"]*' .. var_name,              -- v-show
		'v%-for="[^"]*' .. var_name,               -- v-for
		'v%-bind:[^=]*="[^"]*' .. var_name,        -- v-bind:prop="varName"
		':[^=]*="[^"]*' .. var_name,               -- :prop="varName"
		'@[^=]*="[^"]*' .. var_name,               -- @click="varName" or @click="handler(varName)"
		'v%-on:[^=]*="[^"]*' .. var_name,          -- v-on:click
		'v%-model="[^"]*' .. var_name,             -- v-model
		'v%-slot:[^=]*="[^"]*' .. var_name,        -- v-slot
		'#[^=]*="[^"]*' .. var_name,               -- #slot
		'%(' .. var_name .. '[%s,)]',              -- function call: (varName) or (varName,
		',%s*' .. var_name .. '[%s,)]',            -- in args: , varName)
	}

	for _, pattern in ipairs(patterns) do
		if template_content:match(pattern) then
			return true
		end
	end

	return false
end

-- Smart diagnostic filter: suppress ESLint no-unused-vars for variables used in Pug templates
-- This wraps the default diagnostic handler to filter before display
local original_diagnostic_show = vim.diagnostic.show
vim.diagnostic.show = function(namespace, bufnr, diagnostics, opts)
	bufnr = bufnr or vim.api.nvim_get_current_buf()

	-- Only filter for Vue files
	if vim.bo[bufnr].filetype == "vue" then
		diagnostics = diagnostics or vim.diagnostic.get(bufnr, { namespace = namespace })
		diagnostics = vim.tbl_filter(function(diag)
			-- Check if this is an ESLint no-unused-vars diagnostic
			if diag.source == "eslint" and diag.code == "no-unused-vars" then
				local var_name = diag.message:match("^'([^']+)'")
				if var_name and is_var_used_in_pug_template(bufnr, var_name) then
					return false -- Filter out this diagnostic
				end
			end
			return true
		end, diagnostics)
	end

	return original_diagnostic_show(namespace, bufnr, diagnostics, opts)
end

vim.diagnostic.config({
	virtual_text = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = true,
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.INFO] = "󰋽 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
		},
		numhl = {
			[vim.diagnostic.severity.ERROR] = "ErrorMsg",
			[vim.diagnostic.severity.WARN] = "WarningMsg",
		},
	},
})

-- Extras

local function restart_lsp(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = bufnr })

	for _, client in ipairs(clients) do
		vim.lsp.stop_client(client.id)
	end

	vim.defer_fn(function()
		vim.cmd("edit")
	end, 100)
end

vim.api.nvim_create_user_command("LspRestart", function()
	restart_lsp()
end, {})

local function lsp_status()
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = bufnr })

	if #clients == 0 then
		print("󰅚 No LSP clients attached")
		return
	end

	print("󰒋 LSP Status for buffer " .. bufnr .. ":")
	print("─────────────────────────────────")

	for i, client in ipairs(clients) do
		print(string.format("󰌘 Client %d: %s (ID: %d)", i, client.name, client.id))
		print("  Root: " .. (client.config.root_dir or "N/A"))
		print("  Filetypes: " .. table.concat(client.config.filetypes or {}, ", "))

		-- Check capabilities
		local caps = client.server_capabilities
		local features = {}
		if caps.completionProvider then
			table.insert(features, "completion")
		end
		if caps.hoverProvider then
			table.insert(features, "hover")
		end
		if caps.definitionProvider then
			table.insert(features, "definition")
		end
		if caps.referencesProvider then
			table.insert(features, "references")
		end
		if caps.renameProvider then
			table.insert(features, "rename")
		end
		if caps.codeActionProvider then
			table.insert(features, "code_action")
		end
		if caps.documentFormattingProvider then
			table.insert(features, "formatting")
		end

		print("  Features: " .. table.concat(features, ", "))
		print("")
	end
end

vim.api.nvim_create_user_command("LspStatus", lsp_status, { desc = "Show detailed LSP status" })

local function check_lsp_capabilities()
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = bufnr })

	if #clients == 0 then
		print("No LSP clients attached")
		return
	end

	for _, client in ipairs(clients) do
		print("Capabilities for " .. client.name .. ":")
		local caps = client.server_capabilities

		local capability_list = {
			{ "Completion", caps.completionProvider },
			{ "Hover", caps.hoverProvider },
			{ "Signature Help", caps.signatureHelpProvider },
			{ "Go to Definition", caps.definitionProvider },
			{ "Go to Declaration", caps.declarationProvider },
			{ "Go to Implementation", caps.implementationProvider },
			{ "Go to Type Definition", caps.typeDefinitionProvider },
			{ "Find References", caps.referencesProvider },
			{ "Document Highlight", caps.documentHighlightProvider },
			{ "Document Symbol", caps.documentSymbolProvider },
			{ "Workspace Symbol", caps.workspaceSymbolProvider },
			{ "Code Action", caps.codeActionProvider },
			{ "Code Lens", caps.codeLensProvider },
			{ "Document Formatting", caps.documentFormattingProvider },
			{ "Document Range Formatting", caps.documentRangeFormattingProvider },
			{ "Rename", caps.renameProvider },
			{ "Folding Range", caps.foldingRangeProvider },
			{ "Selection Range", caps.selectionRangeProvider },
		}

		for _, cap in ipairs(capability_list) do
			local status = cap[2] and "✓" or "✗"
			print(string.format("  %s %s", status, cap[1]))
		end
		print("")
	end
end

vim.api.nvim_create_user_command("LspCapabilities", check_lsp_capabilities, { desc = "Show LSP capabilities" })

local function lsp_diagnostics_info()
	local bufnr = vim.api.nvim_get_current_buf()
	local diagnostics = vim.diagnostic.get(bufnr)

	local counts = { ERROR = 0, WARN = 0, INFO = 0, HINT = 0 }

	for _, diagnostic in ipairs(diagnostics) do
		local severity = vim.diagnostic.severity[diagnostic.severity]
		counts[severity] = counts[severity] + 1
	end

	print("󰒡 Diagnostics for current buffer:")
	print("  Errors: " .. counts.ERROR)
	print("  Warnings: " .. counts.WARN)
	print("  Info: " .. counts.INFO)
	print("  Hints: " .. counts.HINT)
	print("  Total: " .. #diagnostics)
end

vim.api.nvim_create_user_command("LspDiagnostics", lsp_diagnostics_info, { desc = "Show LSP diagnostics count" })

local function lsp_info()
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = bufnr })

	print("═══════════════════════════════════")
	print("           LSP INFORMATION          ")
	print("═══════════════════════════════════")
	print("")

	-- Basic info
	print("󰈙 Language client log: " .. vim.lsp.get_log_path())
	print("󰈔 Detected filetype: " .. vim.bo.filetype)
	print("󰈮 Buffer: " .. bufnr)
	print("󰈔 Root directory: " .. (vim.fn.getcwd() or "N/A"))
	print("")

	if #clients == 0 then
		print("󰅚 No LSP clients attached to buffer " .. bufnr)
		print("")
		print("Possible reasons:")
		print("  • No language server installed for " .. vim.bo.filetype)
		print("  • Language server not configured")
		print("  • Not in a project root directory")
		print("  • File type not recognized")
		return
	end

	print("󰒋 LSP clients attached to buffer " .. bufnr .. ":")
	print("─────────────────────────────────")

	for i, client in ipairs(clients) do
		print(string.format("󰌘 Client %d: %s", i, client.name))
		print("  ID: " .. client.id)
		print("  Root dir: " .. (client.config.root_dir or "Not set"))
		print("  Command: " .. table.concat(client.config.cmd or {}, " "))
		print("  Filetypes: " .. table.concat(client.config.filetypes or {}, ", "))

		-- Server status
		if client.is_stopped() then
			print("  Status: 󰅚 Stopped")
		else
			print("  Status: 󰄬 Running")
		end

		-- Workspace folders
		if client.workspace_folders and #client.workspace_folders > 0 then
			print("  Workspace folders:")
			for _, folder in ipairs(client.workspace_folders) do
				print("    • " .. folder.name)
			end
		end

		-- Attached buffers count
		local attached_buffers = {}
		for buf, _ in pairs(client.attached_buffers or {}) do
			table.insert(attached_buffers, buf)
		end
		print("  Attached buffers: " .. #attached_buffers)

		-- Key capabilities
		local caps = client.server_capabilities
		local key_features = {}
		if caps.completionProvider then
			table.insert(key_features, "completion")
		end
		if caps.hoverProvider then
			table.insert(key_features, "hover")
		end
		if caps.definitionProvider then
			table.insert(key_features, "definition")
		end
		if caps.documentFormattingProvider then
			table.insert(key_features, "formatting")
		end
		if caps.codeActionProvider then
			table.insert(key_features, "code_action")
		end

		if #key_features > 0 then
			print("  Key features: " .. table.concat(key_features, ", "))
		end

		print("")
	end

	-- Diagnostics summary
	local diagnostics = vim.diagnostic.get(bufnr)
	if #diagnostics > 0 then
		print("󰒡 Diagnostics Summary:")
		local counts = { ERROR = 0, WARN = 0, INFO = 0, HINT = 0 }

		for _, diagnostic in ipairs(diagnostics) do
			local severity = vim.diagnostic.severity[diagnostic.severity]
			counts[severity] = counts[severity] + 1
		end

		print("  󰅚 Errors: " .. counts.ERROR)
		print("  󰀪 Warnings: " .. counts.WARN)
		print("  󰋽 Info: " .. counts.INFO)
		print("  󰌶 Hints: " .. counts.HINT)
		print("  Total: " .. #diagnostics)
	else
		print("󰄬 No diagnostics")
	end

	print("")
	print("Use :LspLog to view detailed logs")
	print("Use :LspCapabilities for full capability list")
end

-- Create command
vim.api.nvim_create_user_command("LspInfo", lsp_info, { desc = "Show comprehensive LSP information" })

local function lsp_status_short()
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = bufnr })

	if #clients == 0 then
		return "" -- Return empty string when no LSP
	end

	local names = {}
	for _, client in ipairs(clients) do
		table.insert(names, client.name)
	end

	return "󰒋 " .. table.concat(names, ",")
end

local function git_branch()
	local ok, handle = pcall(io.popen, "git branch --show-current 2>/dev/null")
	if not ok or not handle then
		return ""
	end
	local branch = handle:read("*a")
	handle:close()
	if branch and branch ~= "" then
		branch = branch:gsub("\n", "")
		return "󰊢 " .. branch
	end
	return ""
end

local function formatter_status()
	local ok, conform = pcall(require, "conform")
	if not ok then
		return ""
	end

	local formatters = conform.list_formatters_to_run(0)
	if #formatters == 0 then
		return ""
	end

	local formatter_names = {}
	for _, formatter in ipairs(formatters) do
		table.insert(formatter_names, formatter.name)
	end

	return "󰉿 " .. table.concat(formatter_names, ",")
end

local function linter_status()
	local ok, lint = pcall(require, "lint")
	if not ok then
		return ""
	end

	local linters = lint.linters_by_ft[vim.bo.filetype] or {}
	if #linters == 0 then
		return ""
	end

	return "󰁨 " .. table.concat(linters, ",")
end
-- Safe wrapper functions for statusline
local function safe_git_branch()
	local ok, result = pcall(git_branch)
	return ok and result or ""
end

local function safe_lsp_status()
	local ok, result = pcall(lsp_status_short)
	return ok and result or ""
end

local function safe_formatter_status()
	local ok, result = pcall(formatter_status)
	return ok and result or ""
end

local function safe_linter_status()
	local ok, result = pcall(linter_status)
	return ok and result or ""
end

_G.git_branch = safe_git_branch
_G.lsp_status = safe_lsp_status
_G.formatter_status = safe_formatter_status
_G.linter_status = safe_linter_status

-- THEN set the statusline
vim.opt.statusline = table.concat({
	"%{v:lua.git_branch()}", -- Git branch
	"%f", -- File name
	"%m", -- Modified flag
	"%r", -- Readonly flag
	"%=", -- Right align
	"%{v:lua.linter_status()}", -- Linter status
	"%{v:lua.formatter_status()}", -- Formatter status
	"%{v:lua.lsp_status()}", -- LSP status
	" %l:%c", -- Line:Column
	" %p%%", -- Percentage through file
}, " ")
