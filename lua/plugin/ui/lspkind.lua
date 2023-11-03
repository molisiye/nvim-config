local custome = require("custome")

return {
	"onsails/lspkind.nvim",
	lazy = true,
	config = function()
		require("lspkind").init({
			symbol_map = custome.icons.kind,
		})
	end,
}
