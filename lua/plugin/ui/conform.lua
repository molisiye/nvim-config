return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			c = { "clang_format" },
			html = { "prettierd" },
			json = { "prettierd" },
			jsonc = { "prettierd" },
			bash = { "shfmt" },
			lua = { "stylua" },
			-- Conform will use the first available formatter in the list
			javascript = { "prettierd" },
			typescript = { "prettierd" },
			javascriptreact = { "prettierd" },
			typescriptreact = { "prettierd" },
			vue = { "prettierd" },
			-- Formatters can also be specified with additional options
			python = {
				formatters = { "isort", "black" },
				-- Run formatters one after another instead of stopping at the first success
				run_all_formatters = true,
			},
			markdown = {
				"prettierd",
				"markdownlint",
			},
		},
	},
}
