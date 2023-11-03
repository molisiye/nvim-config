return {
	"folke/flash.nvim",
	opts = {
		modes = {
			search = {
				highlight = {
					backdrop = true,
				},
			},
			char = {
				enabled = false,
			},
			treesitter = {
				highlight = {
					backdrop = true,
				},
			},
		},
	},
	event = "VeryLazy",
}
