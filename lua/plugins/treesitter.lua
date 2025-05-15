---@diagnostic disable
return {
	"nvim-treesitter/nvim-treesitter",
	event = "VeryLazy",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"bash",
				"fish",
				"c",
				"cpp",
				"ruby",
				"rust",
				"javascript",
				"json",
				"lua",
				"python",
				"typescript",
				"tsx",
				"css",
				"yaml",
				"markdown",
				"markdown_inline",
			}, -- one of "all" or a list of languages
			highlight = {
				enable = true, -- false will disable the whole extension
			},
			indent = { enable = true },
			autotag = { enable = true },
			endwise = { enable = true },
		})
	end,
}
