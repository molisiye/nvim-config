local fn = vim.fn

-- Install your plugins here
require("lazy").setup({ { import = "plugins" }}, {
	defaults = { lazy = true },
	dev = {
		path = "~/coding/nvim",
		fallback = true,
	},
	performance = {
		rtp = {
			disabled_plugins = {
				"tohtml",
				"gzip",
				"zipPlugin",
				"netrwPlugin",
				"tarPlugin",
			},
		},
	},
})

vim.keymap.set("n", "<leader>mp", "<Cmd>Lazy<CR>", { desc = "Plugins" })
