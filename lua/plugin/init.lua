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

-- Use a protected call so we don't error out on first use
local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
	vim.notify("not found lazy")
	return
end

-- Install your plugins here
lazy.setup({
	-- manage itself
	"folke/lazy.nvim",
	{
		"alker0/chezmoi.vim",
		lazy = false,
		init = function()
			vim.g["chezmoi#use_tmp_buffer"] = true
		end,
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("plugin.neotree")
		end,
	},
	-- symbol line
	{
		"stevearc/aerial.nvim",
		event = "VeryLazy",
		config = function()
			require("plugin.aerial")
		end,
	},
	{
		"numToStr/Comment.nvim",
		dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
		config = function()
			require("plugin.comment")
		end,
	},
	{
		"nanozuki/tabby.nvim",
		config = function()
			require("plugin.tabby")
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			require("plugin.lualine")
		end,
	},
	{
		"akinsho/toggleterm.nvim",
		config = function()
			require("plugin.toggleterm")
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		config = function()
			require("plugin.ibl")
		end,
	},
	{
		"goolord/alpha-nvim",
		event = "VIMEnter",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("plugin.alpha")
		end,
	},
	{
		"folke/which-key.nvim",
		config = function()
			require("plugin.whichkey")
		end,
	},
	"khaveesh/vim-fish-syntax",

	-- Colorschemes
	"folke/tokyonight.nvim",
	"lunarvim/darkplus.nvim",
	{
		"neanias/everforest-nvim",
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme everforest]])
		end,
	},

	-- Cmp
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			-- async path
			"Felipelema/cmp-async-path",
			"lukas-reineke/cmp-rg",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-nvim-lsp-document-symbol",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"windwp/nvim-autopairs",
			-- Snippets
			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",
		},
		event = "VeryLazy",
		config = function()
			require("plugin.cmp")
		end,
	},

	-- LSP
	{
		"williamboman/mason.nvim",
		--		event = "VeryLazy",
		dependencies = {
			"neovim/nvim-lspconfig",
			"williamboman/mason-lspconfig.nvim",
			{
				"mfussenegger/nvim-dap",
				dependencies = {
					"rcarriga/nvim-dap-ui",
				},
			},
			"folke/neodev.nvim",
		},
		config = function()
			require("plugin.lsp")
		end,
	},

	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"debugloop/telescope-undo.nvim",
			{
				--"nvim-telescope/telescope-fzf-native.nvim",
				--build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
			},
		},
		config = function()
			require("plugin.telescope")
		end,
	},

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
		build = ":TSUpdate",
		config = function()
			require("plugin.treesitter")
		end,
	},

	-- Git
	{ "lewis6991/gitsigns.nvim", event = "VeryLazy" },
	{
		"kevinhwang91/nvim-ufo",
		dependencies = {
			"kevinhwang91/promise-async",
			{
				"luukvbaal/statuscol.nvim",
				config = function()
					local builtin = require("statuscol.builtin")
					require("statuscol").setup({
						relculright = true,
						segments = {
							{ text = { builtin.foldfunc }, click = "v:lua.ScFa" },
							{ text = { "%s" }, click = "v:lua.ScSa" },
							{ text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
						},
					})
				end,
			},
		},
		event = "BufReadPost",
        config = function ()
            require("plugin.nvim-ufo")
        end
	},
	{
		"stevearc/conform.nvim",
		config = function()
			require("plugin.conform")
		end,
	},
	{
		"folke/trouble.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
	},
	{
		"catppuccin/nvim",
		enabled = true,
		name = "catppuccin",
		priority = 1000,
		config = function()
			local catppuccin = require("catppuccin")
			catppuccin.setup({
				flavour = "mocha",
			})
		end,
	},
})
