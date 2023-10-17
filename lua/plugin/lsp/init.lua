local status, mason = pcall(require, "mason")
if not status then
	vim.notify("not found mason")
	return
end

mason.setup()

local lspconfig = require("lspconfig")
local mason_lspconfig = require("mason-lspconfig")

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

local default_config = require("plugin.lsp.handlers")
local servers_handlers = {}

for _, server in pairs(servers) do
	local require_ok, conf_opts = pcall(require, "settings." .. server)
	if not require_ok then
		conf_opts = {}
	end
	--opts = vim.tbl_deep_extend("force", conf_opts, opts)
	--lspconfig[server].setup(opts)
	servers_handlers[server] = function()
		lspconfig[server].setup(vim.tbl_deep_extend("force", default_config(), conf_opts))
	end
end

mason_lspconfig.setup({
	ensure_installed = servers,
	handlers = servers_handlers,
	automatic_installation = true,
})
