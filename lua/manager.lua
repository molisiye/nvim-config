local fn = vim.fn

-- Automatically install lazy.nvim
local lazypath = fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim",
		"--branch=stable", --latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Install your plugins here
require("lazy").setup({ import = "plugin" }, {
	dev = {
		path = "~/coding/nvim",
		fallback = true,
	},
})

vim.keymap.set("n", "<leader>mp", "<Cmd>Lazy<CR>", { desc = "Plugins" })
