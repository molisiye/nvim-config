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

local settings = {
  ui = {
    border = "none",
    icons = {
      package_installed = "◍",
      package_pending = "◍",
      package_uninstalled = "◍",
    },
  },
  log_level = vim.log.levels.INFO,
  max_concurrent_installers = 4,
}

require("mason").setup(settings)
require("mason-lspconfig").setup({
  ensure_installed = servers,
  automatic_installation = true,
})


local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
  return
end

local opts = {
}

local function on_attach(client, bufnr)
  require("lsp.handlers").on_attach(client, bufnr)
end
for _, server in pairs(servers) do
  opts = {
    on_attach = on_attach,
    capabilities = require("lsp.handlers").capabilities,
    single_file_support = true,
  }

  server = vim.split(server, "@")[1]

  local require_ok, conf_opts = pcall(require, "lsp.settings." .. server)
  if require_ok then
    opts = vim.tbl_deep_extend("force", conf_opts, opts)
  end
  lspconfig[server].setup(opts)
end

lspconfig["serve_d"].setup({
  -- disable default formatting
  capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
  on_attach = function(client)
    client.server_capabilities.documentFormattingProvider = false
  end,
})
