return {
	"catppuccin/nvim",
	name = "catppuccin",
	lazy = true,
	opts = {
		term_colors = true,
		integrations = {
			aerial = true,
			fidget = true,
			markdown = true,
			mason = true,
			neotree = true,
			navic = {
				enabled = true,
			},
			noice = true,
			notify = true,
			treesitter_context = true,
			octo = true,
			overseer = true,
			symbols_outline = true,
			ufo = false,
			which_key = true,
		},
	},
}
