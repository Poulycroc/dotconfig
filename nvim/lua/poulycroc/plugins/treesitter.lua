-- skips parsers already installed; run :TSUpdate after updating the plugin
require("nvim-treesitter").install({
	"bash",
	"blade",
	"c",
	"css",
	"diff",
	"go",
	"gomod",
	"gosum",
	"gowork",
	"graphql",
	"html",
	"javascript",
	"jsdoc",
	"json",
	"json5",
	"lua",
	"luadoc",
	"luap",
	"markdown",
	"markdown_inline",
	"php",
	"proto",
	"pug",
	"python",
	"query",
	"regex",
	"rust",
	"terraform",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"vue",
	"yaml",
	"zig",
})

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
	callback = function(args)
		if pcall(vim.treesitter.start, args.buf) then
			vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end,
})
