return {
	"williamboman/mason-lspconfig.nvim",
	dependencies = {
		"mason.nvim",
		"neovim/nvim-lspconfig",
		"b0o/SchemaStore.nvim",
		"folke/neodev.nvim",
	},
	config = function()
		local lspconfig = require("lspconfig")
		local mason_lspconfig = require("mason-lspconfig")
		-- require("mason").setup()

		local servers = {
			"lua_ls",
			"serve_d",
			"clangd",
			-- "cssls",
			-- "html",
			-- "tsserver",
			"pyright",
			-- "bashls",
			"jsonls",
			-- "yamlls",
		}
		local default = require("lsp")
		local default_config = default.default_config
		local servers_handlers = {}

		for _, server in pairs(servers) do
			local require_ok, conf_opts = pcall(require, "plugin.lsp.settings." .. server)
			if not require_ok then
				conf_opts = {}
			end
			--opts = vim.tbl_deep_extend("force", conf_opts, opts)
			--lspconfig[server].setup(opts)
			servers_handlers[server] = function()
				lspconfig[server].setup(vim.tbl_deep_extend("force", default_config(), conf_opts))
			end
		end
        -- print(vim.inspect(vim.inspect(servers_handlers)))
        -- print(vim.inspect(servers_handlers["lua_ls"]))
		mason_lspconfig.setup({
			ensure_installed = servers,
			handlers = servers_handlers,
			automatic_installation = true,
		})
	end,
}
