local fn = vim.fn

-- Automatically install packer
local lazypath = fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    fn.system({"git", "clone", "--filter=blob:none", 
    "https://github.com/folke/lazy.nvim",
    "--branch=stable", --latest stable release
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)


-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "lazy")
if not status_ok then
    return
end


-- Install your plugins here
return packer.setup({
    "wbthomason/packer.nvim",
    "nvim-lua/plenary.nvim",
    "windwp/nvim-autopairs",
    "numToStr/Comment.nvim",
    "JoosepAlviste/nvim-ts-context-commentstring",
    "kyazdani42/nvim-web-devicons",
    "kyazdani42/nvim-tree.lua",
    "akinsho/bufferline.nvim",
    "moll/vim-bbye",
    "nvim-lualine/lualine.nvim",
    "akinsho/toggleterm.nvim",
    "ahmedkhalf/project.nvim",
    "lewis6991/impatient.nvim",
    "lukas-reineke/indent-blankline.nvim",
    "goolord/alpha-nvim",
    "folke/which-key.nvim",
    "khaveesh/vim-fish-syntax",

    -- Colorschemes
    "folke/tokyonight.nvim",
    "lunarvim/darkplus.nvim",
    "neanias/everforest-nvim",

    -- Cmp 
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lua",

    -- Snippets
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",

    -- LSP
    "neovim/nvim-lspconfig",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "jose-elias-alvarez/null-ls.nvim",
    "RRethy/vim-illuminate",
    "ii14/emmylua-nvim",

    -- Telescope
    "nvim-telescope/telescope.nvim",

    -- Treesitter
    "nvim-treesitter/nvim-treesitter",

    -- Git
    "lewis6991/gitsigns.nvim",
}) 

