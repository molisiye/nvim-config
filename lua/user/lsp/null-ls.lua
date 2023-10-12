local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
	debug = false,
	sources = {
		formatting.prettier.with({ extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" } }),
		formatting.black.with({ extra_args = { "--fast" } }),
		formatting.stylua,
    formatting.dfmt.with({
      extra_args = {
        '--brace_style', 'otbs',
        '--align_switch_statements', 'true',
        '--compact_labeled_statements', 'true',
        '--keep_line_breaks', 'true',
        '--indent_style', 'space',
        '--indent_size', '4',
        '--soft_max_line_length', '80',
        '$FILENAME'
      },
      filetypes = { "d", 'dub', 'rdmd' },
    }),
    formatting.stylelint
    -- diagnostics.flake8
	},
})
