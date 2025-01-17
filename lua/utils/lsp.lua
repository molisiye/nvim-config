local M = {}

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
	vim.notify("not found cmp_nvim_lsp")
	return
end

M.capabilities = cmp_nvim_lsp.default_capabilities()

-- for ufo
M.capabilities.textDocument.foldingRange = {
	--	dynamicRegistration = false,
	--	lineFoldingOnly = true,
}

M.default_config = function()
	local opt = {
		single_file_support = true,
		capabilities = M.capabilities,
		on_attach = function(client, bufnr)
			-- Enable completion triggered by <c-x><c-o>
			-- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

			-- Disable the formatting function and leave it to a special plug-in plug-in for processing
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false

			-- Enable inlay hints
			-- if client and client.server_capabilities.inlayHintProvider then
			--	vim.lsp.inlay_hint(bufnr, true)
			--end
			local lsp_mapping = require("util").empty_map_table()

			lsp_mapping.n["gD"] = { "<cmd>lua vim.lsp.buf.declaration()<cr>", desc = "Declaration" }
			lsp_mapping.n["gd"] = { "<cmd>lua vim.lsp.buf.hover()<cr>", desc = "Hover Info" }
			lsp_mapping.n["K"] = { "<cmd>lua vim.lsp.buf.implementation()<cr>", desc = "Implementation" }
			lsp_mapping.n["gI"] = { "<cmd>lua vim.lsp.buf.references", desc = "references" }
			lsp_mapping.n["<leader>ld"] = { "<cmd>lua vim.diagnostic.open_float()<cr>", desc = "Hover diagnostic" }
			lsp_mapping.n["[d"] = {
				function()
					vim.diagnostic.goto_prev()
				end,
				desc = "Previous diagnostic",
			}
			lsp_mapping.n["]d"] = {
				function()
					vim.diagnostic.goto_next()
				end,
				desc = "Next diagnostic",
			}
			lsp_mapping.n["gl"] = { "<cmd>lua vim.diagnostic.open_float()<CR>", desc = "Hover diagnostic" }
			lsp_mapping.n["<leader>li"] = { "<cmd>LspInfo<cr>", desc = "Lsp info" }
			lsp_mapping.n["<leader>lI"] = { "<cmd>LspInstallInfo<cr>", desc = "Lsp install info" }
			lsp_mapping.n["<leader>la"] = { "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code action" }
			lsp_mapping.n["<leader>lr"] = { "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename" }
			lsp_mapping.n["<leader>ls"] = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", desc = "Signature help" }
			lsp_mapping.n["<leader>lq"] = { "<cmd>lua vim.diagnostic.setloclist()<CR>", desc = "Diagnostic list" }
			lsp_mapping.n["<leader>uh"] =
				{ "<cmd>lua vim.lsp.inlay_hint(0,nil)<CR>", desc = "Toggle LSP inlay hints (buffer)" }

			require("util").set_mapping(lsp_mapping)
		end,
	}
	return opt
end

return M
