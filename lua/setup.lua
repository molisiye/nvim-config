-- Install your plugins here
---@diagnostic disable-next-line: missing-fields
require("lazy").setup({ { import = "plugins" } } --[[@as LazySpec]], {
	defaults = { lazy = true },
	dev = {
		path = "~/coding/nvim",
		fallback = true,
	},
	rocks = {
		enabled = false,
	},
	-- install = { colorscheme = { "catppuccin" } },
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
} --[[@as LazyConfig]])

vim.keymap.set("n", "<leader>mp", "<Cmd>Lazy<CR>", { desc = "Plugins" })
