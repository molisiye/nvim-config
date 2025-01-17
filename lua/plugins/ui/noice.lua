local custome = require("custome")

return {
	"folke/noice.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.cmdheight = 0
	end,
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	opts = {
		cmdline = {
			format = {
				search_down = {
					view = "cmdline",
				},
				search_up = {
					view = "cmdline",
				},
			},
		},
		lsp = {
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true,
			},
			message = {
				enabled = false,
			},
		},
		views = {
			cmdline_popup = {
				border = {
					style = custome.border,
				},
			},
			hover = {
				size = {
					max_width = 80,
				},
				border = {
					style = custome.border,
					padding = { 0, custome.border == "none" and 2 or 0 },
				},
				position = {
					row = custome.border == "none" and 1 or 2,
				},
			},
		},
	},
}
