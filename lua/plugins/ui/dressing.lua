local custome = require("custome")

return({
	"stevearc/dressing.nvim",
	event = "VeryLazy",
	opts = {
		input = {
			border = custome.border,
		},
		select = {
			builtin = {
				border = custome.border,
			},
		},
	},
})
