require("lazydev").setup({
	library = {
		-- See the configuration section for more details
		-- Load luvit types when the `vim.uv` word is found
		{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
	},
})

require("blink.cmp").setup({
	fuzzy = { implementation = "lua" },
	signature = { enabled = true },
	keymap = {
		preset = "default",
		["<CR>"] = { "accept", "fallback" },
		["<Tab>"] = {
			"select_next",
			"snippet_forward",
			"fallback",
		},
		["<S-Tab>"] = {
			"select_prev",
			"snippet_backward",
			"fallback",
		},
	},
	appearance = {
		use_nvim_cmp_as_default = false,
		nerd_font_variant = "mono",
	},
	snippets = { preset = "default" },
	sources = {
		default = { "lazydev", "lsp", "path", "snippets", "buffer" },
		per_filetype = {
			lua = { inherit_defaults = true, "lazydev" },
		},
		providers = {
			lazydev = {
				name = "LazyDev",
				module = "lazydev.integrations.blink",
				score_offset = 100,
			},
			-- laravel = {
			-- 	name = "Laravel",
			-- 	module = "laravel.blink_source",
			-- 	enabled = function()
			-- 		return vim.bo.filetype == "php" or vim.bo.filetype == "blade"
			-- 	end,
			-- 	-- kind = "Laravel",
			-- 	score_offset = 1000, -- Highest priority
			-- 	min_keyword_length = 1,
			-- },
			cmdline = {
				min_keyword_length = 2,
			},
		},
	},
	cmdline = {
		enabled = false,
		completion = { menu = { auto_show = true } },
		keymap = {
			["<CR>"] = { "accept_and_enter", "fallback" },
		},
	},
	completion = {
		menu = {
			border = nil,
			scrolloff = 1,
			scrollbar = false,
			draw = {
				columns = {
					{ "kind_icon" },
					{ "label", "label_description", gap = 1 },
					{ "kind" },
					{ "source_name" },
				},
			},
		},
		documentation = {
			window = {
				border = nil,
				scrollbar = false,
				winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc",
			},
			auto_show = true,
			auto_show_delay_ms = 200,
		},
	},
})
