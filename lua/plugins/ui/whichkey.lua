return {
	"folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        -- add operators that will trigger motion and text object completion
        -- to enable all native operators, set the preset / operators plugin above
        icons = {
            breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
            separator = "➜", -- symbol used between a key and it's label
            group = "+", -- symbol prepended to a group
        },
        -- win = {
        --     border = "rounded", -- none, single, double, shadow
        --     position = "bottom", -- bottom, top
        --     margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
        --     padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
        --     winblend = 0,
        -- },
        layout = {
            height = { min = 4, max = 25 }, -- min and max height of the columns
            width = { min = 20, max = 50 }, -- min and max width of the columns
            spacing = 3, -- spacing between columns
            align = "left", -- align columns left, center or right
        },
        -- hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
        show_help = true, -- show help message on the command line when the popup is visible
        -- triggers = "auto", -- automatically setup triggers
        -- triggers = {"<leader>"} -- or specify a list manually
        -- triggers = {
        --     -- list of mode / prefixes that should never be hooked by WhichKey
        --     -- this is mostly relevant for key maps that start with a native binding
        --     -- most people should not need to change this
        --     i = { "j", "k" },
        --     v = { "j", "k" },
        -- },
      preset = "modern",
      defaults = {},
      spec = {
        {
          mode = { "n", "v" },
          { "<leader><tab>", group = "tabs" },
          { "<leader>c", group = "code" },
          { "<leader>d", group = "debug" },
          { "<leader>dp", group = "profiler" },
          { "<leader>f", group = "file/find" },
          { "<leader>g", group = "git" },
          { "<leader>gh", group = "hunks" },
          { "<leader>q", group = "quit/session" },
          { "<leader>s", group = "search" },
          { "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
          { "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
          { "[", group = "prev" },
          { "]", group = "next" },
          { "g", group = "goto" },
          { "gs", group = "suround" },
          { "z", group = "fold" },
          {
            "<leader>b",
            group = "buffer",
            expand = function()
              return require("which-key.extras").expand.buf()
            end,
          },
          {
            "<leader>w",
            group = "windows",
            proxy = "<c-w>",
            expand = function()
              return require("which-key.extras").expand.win()
            end,
          },
          -- better descriptions
          { "gx", desc = "Open with system app" },
        },
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Keymaps (which-key)",
      },
      {
        "<c-w><space>",
        function()
          require("which-key").show({ keys = "<c-w>", loop = true })
        end,
        desc = "Window Hydra Mode (which-key)",
      },
    },
	config = function(_, opts)
        local wk = require("which-key")
        wk.setup(opts)
        if not vim.tbl_isempty(opts.defaults) then
            -- LazyVim.warn("which-key: opts.defaults is deprecated. Please use opts.spec instead.")
            wk.register(opts.defaults)
        end
	end,
}
