return {
	"rcarriga/nvim-notify",
    enabled = false,
	event = "VeryLazy",
	config = function()
		local notify = require("notify")
		notify.setup({
			render = "minimal",
			stages = "static",
			top_down = false,
		})
		vim.notify = notify
	end,
}
