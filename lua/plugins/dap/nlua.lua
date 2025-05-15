return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"jbyuki/one-small-step-for-vimkind",
		config = function()
			local dap = require("dap")
			dap.adapters.nlua = function(callback, conf)
				local adapter = {
					type = "server",
					host = "127.0.0.1",
					port = 8086,
				}

				local dap_run = dap.run
				dap.run = function(c)
					adapter.port = c.port
					adapter.host = c.host
				end
				require("osv").run_this()
				dap.run = dap_run
				callback(adapter)
			end
			dap.configurations.lua = {
				{
					type = "nlua",
					request = "attach",
					name = "Run this file",
					start_neovim = {},
				},
				{
					type = "nlua",
					request = "attach",
					name = "Attach to running Neovim instance (port = 8086)",
					port = 8086,
				},
			}
		end,
	},
}
