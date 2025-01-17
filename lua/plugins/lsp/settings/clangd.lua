local opt = {
	cmd = { "clangd", "--offset-encoding=utf-16", "--inlay-hints=true" },
	root_dir = function()
		return vim.fn.getcwd()
	end,
}
return opt
