return {
	"j-hui/fidget.nvim",
	enabled = false,
	branch = "legacy",
	event = "VeryLazy",
	config = function()
		require("fidget").setup({
			sources = { -- Sources to configure
				["null-ls"] = {
					ignore = true,
				},
			},
		})
	end,
}
