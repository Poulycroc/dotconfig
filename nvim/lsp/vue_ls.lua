local blink = require("blink.cmp")

-- Path to Mason packages
local mason_packages = vim.fn.stdpath("data") .. "/mason/packages"
local vue_language_server_path = mason_packages .. "/vue-language-server"

-- Function to get TypeScript SDK path (prefer local, fallback to global)
local function get_typescript_sdk()
	local local_sdk = vim.fn.getcwd() .. "/node_modules/typescript/lib"
	if vim.fn.isdirectory(local_sdk) == 1 then
		return local_sdk
	end

	-- Try global installation
	local global_root = vim.fn.system("npm root -g"):gsub("\n", ""):gsub("\r", "")
	local global_sdk = global_root .. "/typescript/lib"
	if vim.fn.isdirectory(global_sdk) == 1 then
		return global_sdk
	end

	-- If both fail, return nil to let vue-language-server find it automatically
	return nil
end

return {
	cmd = { "vue-language-server", "--stdio" },
	filetypes = { "vue" },
	root_markers = {
		"package.json",
		"tsconfig.json",
		"jsconfig.json",
		"vue.config.js",
		"vite.config.js",
		"nuxt.config.ts",
		"nuxt.config.js",
		".git",
	},
	init_options = {
		vue = {
			hybridMode = false, -- vue_ls handles everything (avoids ts_ls timing dependency)
		},
		-- Only set typescript config if we have a valid TypeScript installation
		typescript = get_typescript_sdk() and {
			tsdk = get_typescript_sdk(),
		} or nil,
		-- Load Pug plugin for <template lang="pug"> support
		languagePlugins = {
			vue_language_server_path .. "/node_modules/@vue/language-plugin-pug",
		},
	},
	-- Override on_init to suppress the ts_ls warning (ts_ls is configured separately)
	on_init = function(client)
		-- Hybrid mode is enabled, ts_ls with @vue/typescript-plugin handles TS in Vue files
		return true
	end,
	settings = {
		typescript = {
			inlayHints = {
				enumMemberValues = {
					enabled = true,
				},
				functionLikeReturnTypes = {
					enabled = true,
				},
				propertyDeclarationTypes = {
					enabled = true,
				},
				parameterTypes = {
					enabled = true,
					suppressWhenArgumentMatchesName = true,
				},
				variableTypes = {
					enabled = true,
				},
			},
		},
	},
	capabilities = vim.tbl_deep_extend(
		"force",
		{},
		vim.lsp.protocol.make_client_capabilities(),
		blink.get_lsp_capabilities()
	),
}
