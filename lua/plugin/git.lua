local custome = require("custome")

return {
	{
		"NeogitOrg/neogit",
		cmd = "Neogit",
		opts = {
			disable_insert_on_commit = false,
			disable_commit_confirmation = true,
			disable_builtin_notifications = true,
			kind = custome.prefer_tabpage and "tab" or "split",
			integrations = {
				diffview = true,
			},
			sections = {
				stashes = {
					folded = false,
				},
				recent = {
					folded = false,
				},
			},
		},
	},
    {
        "lewis6991/gitsigns.nvim",
        config = require("plugin.configs.gitsigns")
    }
}
