vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticError" })
vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DiagnosticInfo" })
vim.fn.sign_define("DapStopped", { text = "", texthl = "Constant" })
vim.fn.sign_define("DapBreakpointRejected", { text = "" })

return {
	"mfussenegger/nvim-dap",
	event = "VeryLazy",
	config = function()
		local dap = require("dap")
		dap.defaults.fallback.external_terminal = {
			command = "/usr/bin/kitty",
			args = { "--class", "kitty-dap", "--hold", "--detach", "nvim-dap", "-c", "DAP" },
		}
	end,
}
