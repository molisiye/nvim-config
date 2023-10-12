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
local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
    return
end


-- Install your plugins here
return lazy.setup({
    {"alker0/chezmoi.vim",
      lazy =  false,
      init = function()
        vim.g['chezmoi#use_tmp_buffer'] = true
      end
    },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim"
    }
  },
    "nvim-lua/plenary.nvim",
    "windwp/nvim-autopairs",
    "numToStr/Comment.nvim",
    "JoosepAlviste/nvim-ts-context-commentstring",
    "akinsho/bufferline.nvim",
    "nanozuki/tabby.nvim",
    "moll/vim-bbye",
    "nvim-lualine/lualine.nvim",
    "akinsho/toggleterm.nvim",
    "ahmedkhalf/project.nvim",
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
    "folke/neodev.nvim",

    -- Telescope
    "nvim-telescope/telescope.nvim",

    -- Treesitter
    "nvim-treesitter/nvim-treesitter",

    -- Git
    "lewis6991/gitsigns.nvim",
})

