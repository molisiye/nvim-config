return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-lua/popup.nvim",
		"nvim-telescope/telescope-fzy-native.nvim",
		"nvim-telescope/telescope-live-grep-args.nvim",
		"nvim-telescope/telescope-dap.nvim",
		"benfowler/telescope-luasnip.nvim",
		"debugloop/telescope-undo.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local function flash(prompt_bufnr)
			require("flash").jump({
				pattern = "^",
				label = { after = { 0, 0 } },
				search = {
					mode = "search",
					exclude = {
						function(win)
							return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
						end,
					},
				},
				action = function(match)
					local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
					picker:set_selection(match.ops[1] - 1)
				end,
			})
		end

		telescope.setup({
			defaults = {
				prompt_prefix = " ",
				selection_caret = " ",
				path_display = { "smart" },
				mappings = {
					n = { s = flash },
					i = { ["<c-s>"] = flash },
				},
			},
			pickers = {
				-- Default configuration for builtin pickers goes here:
				-- picker_name = {
				--   picker_config_key = value,
				--   ...
				-- }
				-- Now the picker_config_key will be applied every time you call this
				-- builtin picker
				find_files = { theme = "ivy" },
				oldfiles = { theme = "ivy" },
			},
			extensions = {
				-- Your extension configuration goes here:
				-- extension_name = {
				--   extension_config_key = value,
				-- }
				-- please take a look at the readme of the extension you want to configure
				aerial = {
					-- Display symbols as <root>.<parent>.<symbol>
					show_nesting = {
						["_"] = false, -- This key will be the default
						json = true, -- You can set the option for specific filetypes
						yaml = true,
					},
				},
				live_grep_args = { theme = "dropdown" },
			},
		})

		-- Telescope extensions
		local extensions = {
			"dap",
			"aerial",
			"fzy_native",
			"notify",
			"live_grep_args",
			"luasnip",
		}

		for _, ext in ipairs(extensions) do
			local ok = pcall(telescope.load_extension, ext)
			if not ok then
				vim.print("Failed to load telescope extension: " .. ext)
			end
		end
	end,
    cmd={"Telescope"}
}
