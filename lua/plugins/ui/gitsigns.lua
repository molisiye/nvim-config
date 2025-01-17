local custom = require "custome"
local utils = require "utils.common"

return {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    dependencies = "nvim-lua/plenary.nvim",
    keys={
        {
            "<leader>gB",
            function ()
                require("gitsigns").blame()
            end,
            desc="Blame"
        }
    },
    opts = {
        word_diff=true,
        attach_to_untracked=true,
        preview_config={
            border=custom.border,
        },
        on_attach = function(bufnr)
            local gitsigns = require "gitsigns"
            local next_hunk, prev_hunk = utils.make_repeatable_move_pair(function ()
                gitsigns.nav_hunk "next"
            end, function()
                gitsigns.nav_hunk "prev"
            end)

            -- Navigation
            vim.keymap.set("n", "]h", function ()
                if vim.wo.diff then
                    vim.cmd.normal {"]h", bang = true}
                else
                    next_hunk()
                end
            end, {buffer=bufnr,desc="Next hunk"})
        end
    },
    config = function (_,opts)
        require("gitsigns").setup(opts)

        local function set_hl()
            vim.api.nvim_set_hl(0, "GitSignsChangeLn", {link = "DiffText"})
        end
        set_hl()
        vim.api.nvim_create_autocmd("ColorScheme", {
            desc = "Set gitsigns highlights",
            callback = set_hl,
        })
    end
}
