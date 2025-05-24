return {
	{
		"mason-org/mason.nvim",
		config = function()
			require("mason").setup({
				PATH = "prepend",
			})
		end,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"fortls",
					-- "nil_ls",
					"bashls",
					"cmake",
					"lua_ls",
					"rust_analyzer",
					-- "gopls",
					"templ",
					"html",
					"cssls",
					"emmet_language_server",
					-- "htmx",
					"tailwindcss",
					"ts_ls",
					"astro",
					"ols",
					-- "gdscript",
					-- "tsserver",
					"pylsp",
					"clangd",
					"prismals",
					"yamlls",
					"jsonls",
					"eslint",
					-- "hls",
					-- "zls",
					"marksman",
					"sqlls",
					"wgsl_analyzer",
					"texlab",
					"intelephense",
					"nim_langserver",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"saghen/blink.cmp",
			{ "antosha417/nvim-lsp-file-operations", config = true },
			{ "folke/neodev.nvim", opts = {} },
		},
		config = function()
			-- LSP keymaps
			local keymap = vim.keymap.set
			local opts = { noremap = true, silent = true }

			local on_attach = function(client, bufnr)
				opts.buffer = bufnr

				opts.desc = "LSP References"
				keymap("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

				opts.desc = "Rename the variable under your cursor"
				keymap("n", "grn", vim.lsp.buf.rename, opts)

				opts.desc = "Go to declaration"
				keymap("n", "gD", vim.lsp.buf.declaration, opts)

				opts.desc = "Go to definition"
				keymap("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

				opts.desc = "See available code actions"
				keymap("n", "<leader>vca", vim.lsp.buf.code_action, opts)

				opts.desc = "Show LSP implementations"
				keymap("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

				opts.desc = "Show documentation for what is under cursor"
				keymap("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

				opts.desc = "Restart LSP"
				keymap("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
			end

			-- LSP configuration
			--
			-- local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			local lspconfig = require("lspconfig")
			local configs = require("lspconfig.configs")

			lspconfig.cmake.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})
			lspconfig.fortls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				root_dir = require("lspconfig").util.root_pattern("*.f90"),
			})
			lspconfig.purescriptls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "purescript" },
				settings = {
					purescript = {
						addSpagoSources = true, -- e.g. any purescript language-server config here
					},
				},
				flags = {
					debounce_text_changes = 150,
				},
			})
			lspconfig.ols.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				root_dir = require("lspconfig").util.root_pattern("*.odin"),
			})
			lspconfig.ocamllsp.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				cmd = { "ocamllsp", "--stdio" },
				filetypes = { "ocaml", "reason" },
				root_dir = require("lspconfig").util.root_pattern("*.opam", "esy.json", "package.json"),
			})
			if not configs.roc_ls then
				configs.roc_ls = {
					default_config = {
						cmd = { "roc_language_server", "--stdio" },
						capabilties = capabilities,
						filetypes = {
							"roc",
						},
						single_file_support = true,
					},
				}
			end
			lspconfig.roc_ls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})
			lspconfig.gdscript.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "gd", "gdscript", "gdscript3" },
			})
			lspconfig.astro.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})
			lspconfig.nil_ls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})
			lspconfig.sqlls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})
			lspconfig.intelephense.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})
			lspconfig.texlab.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})
			lspconfig.zls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				cmd = { "zls" },
			})
			lspconfig.hls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				single_file_support = true,
			})
			lspconfig.bashls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				-- cmd = { "lua_ls" },
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" }, -- Recognize 'vim' as a global variable
						},
						workspace = {
							library = {
								vim.api.nvim_get_runtime_file("", true),
								"${3rd}/love2d/library",
							}, -- Include Neovim runtime files
						},
						telemetry = {
							enable = false,
						},
					},
				},
			})
			lspconfig.wgsl_analyzer.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})
			lspconfig.jsonls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})
			lspconfig.gopls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})
			lspconfig.cssls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})
			lspconfig.prismals.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})
			lspconfig.yamlls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})
			lspconfig.html.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = {
					"templ",
					"html",
					"php",
					"css",
					"javascriptreact",
					"typescriptreact",
					"javascript",
					"typescript",
					"jsx",
					"tsx",
				},
			})
			lspconfig.htmx.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "html", "templ" },
			})
			lspconfig.emmet_language_server.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = {
					"templ",
					"html",
					"css",
					"php",
					"javascriptreact",
					"typescriptreact",
					"javascript",
					"typescript",
					"jsx",
					"tsx",
					"markdown",
				},
			})
			-- lspconfig.tailwindcss.setup({
			-- 	capabilities = capabilities,
			-- 	filetypes = {
			-- 		"templ",
			-- 		"html",
			-- 		"css",
			-- 		"javascriptreact",
			-- 		"typescriptreact",
			-- 		"javascript",
			-- 		"typescript",
			-- 		"jsx",
			-- 		"tsx",
			-- 	},
			-- 	root_dir = require("lspconfig").util.root_pattern(
			-- 		"tailwind.config.js",
			-- 		"tailwind.config.cjs",
			-- 		"tailwind.config.mjs",
			-- 		"tailwind.config.ts",
			-- 		"postcss.config.js",
			-- 		"postcss.config.cjs",
			-- 		"postcss.config.mjs",
			-- 		"postcss.config.ts",
			-- 		"package.json",
			-- 		"node_modules",
			-- 		".git"
			-- 	),
			-- })
			lspconfig.templ.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "templ" },
			})

			if not configs.ts_ls then
				configs.ts_ls = {
					default_config = {
						cmd = { "typescript-language-server", "--stdio" },
						capabilties = capabilities,
						filetypes = {
							"javascript",
							"javascriptreact",
							"typescript",
							"typescriptreact",
							"html",
						},
						root_dir = require("lspconfig").util.root_pattern("package.json", "tsconfig.json", ".git"),
						single_file_support = true,
					},
				}
			end
			lspconfig.ts_ls.setup({
				cmd = { "typescript-language-server", "--stdio" },
				capabilties = capabilities,
				on_attach = on_attach,
				filetypes = {
					"javascript",
					"javascriptreact",
					"typescript",
					"typescriptreact",
					"html",
				},
				root_dir = require("lspconfig").util.root_pattern("package.json", "tsconfig.json", ".git"),
				single_file_support = true,
			})
			lspconfig.eslint.setup({
				capabilties = capabilities,
				on_attach = on_attach,
			})

			require("lspconfig").clangd.setup({
				cmd = {
					"clangd",
					"--background-index",
					"--pch-storage=memory",
					"--all-scopes-completion",
					"--pretty",
					"--header-insertion=never",
					"-j=4",
					"--inlay-hints",
					"--header-insertion-decorators",
					"--function-arg-placeholders",
					"--completion-style=detailed",
				},
				filetypes = { "c", "cpp", "objc", "objcpp" },
				root_dir = require("lspconfig").util.root_pattern("src"),
				init_option = { fallbackFlags = { "-std=c++2a" } },
				capabilities = capabilities,
				on_attach = on_attach,
				single_file_support = true,
			})

			function get_python_path()
				-- Check if there's an active virtual environment
				local venv_path = os.getenv("VIRTUAL_ENV")
				if venv_path then
					return venv_path .. "/bin/python3"
				else
					-- get os name
					local os_name = require("poulycroc.utils").get_os()
					-- get os interpreter path
					if os_name == "windows" then
						return "C:/python312"
					elseif os_name == "linux" then
						return "/usr/bin/python3"
					else
						return "/Library/Frameworks/Python.framework/Versions/3.11/bin/python3"
					end
					-- Fallback to global Python interpreter
				end
			end

			lspconfig.pylsp.setup({
				capabilties = capabilities,
				on_attach = on_attach,
				settings = {
					python = {
						pythonPath = get_python_path(),
					},
				},
			})

			lspconfig.marksman.setup({
				capabilties = capabilities,
				on_attach = on_attach,
			})
			lspconfig.gleam.setup({
				capabilties = capabilities,
				on_attach = on_attach,
			})
			lspconfig.nim_langserver.setup({
				capabilties = capabilities,
				on_attach = on_attach,
			})
		end,
	},
}
