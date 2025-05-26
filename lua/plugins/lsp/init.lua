return {
	{
		"williamboman/mason-lspconfig.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"mason.nvim",
			"neovim/nvim-lspconfig",
			"b0o/SchemaStore.nvim",
		},
		config = function()
			local lspconfig = require("lspconfig")
			local mason_lspconfig = require("mason-lspconfig")
			-- require("mason").setup()

			local servers = {
				"lua_ls",
				"serve_d",
				"clangd",
				"cmake",
                "solargraph",
				-- "cssls",
				-- "html",
				-- "tsserver",
				"pyright",
				-- "bashls",
				"jsonls",
				-- "yamlls",
			}
			local lsp = require("utils.lsp")
			local default_config = lsp.default_config
			local servers_handlers = {}

			for _, server in pairs(servers) do
				local require_ok, conf_opts = pcall(require, "plugins.lsp.settings." .. server)
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
	},
	-- cmdline tools and lsp servers
    -- copy from lazyvim
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		build = ":MasonUpdate",
		opts_extend = { "ensure_installed" },
		opts = {
			ensure_installed = {
				"stylua",
				"shfmt",
			},
		},
		---@param opts MasonSettings | {ensure_installed: string[]}
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")
			mr:on("package:install:success", function()
				vim.defer_fn(function()
					-- trigger FileType event to possibly load this newly installed LSP server
					require("lazy.core.handler.event").trigger({
						event = "FileType",
						buf = vim.api.nvim_get_current_buf(),
					})
				end, 100)
			end)

			mr.refresh(function()
				for _, tool in ipairs(opts.ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end)
		end,
	},
}
