local custome = require("custome")

for _, source in ipairs({
	"options",
	"manager",
	"keymaps",
}) do
	local status_ok, fault = pcall(require, source)
	if not status_ok then
		vim.api.nvim_err_writeln("Failed to load " .. source .. "\n" .. fault)
	end
end

vim.cmd.colorscheme(custome.theme)
