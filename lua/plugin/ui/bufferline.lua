local custome = require("custome")
local util = require("util")

local mode = custome.prefer_tabpage and "tabs" or "buffers"

return {
	"akinsho/bufferline.nvim",
	event = "VimEnter",
	version = "*",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	init = function()
		vim.o.showtabline = 2
		vim.o.tabline = " "
	end,
	config = function()
		---@diagnostic disable-next-line: missing-fields
		require("bufferline").setup({
			---@diagnostic disable-next-line: missing-fields
			options = {
                mode,
				-- To close the Tab command, use moll/vim-bbye's :Bdelete command here
				close_command = "Bdelete! %d",
				right_mouse_command = "Bdelete! %d",
				-- Using nvim's built-in LSP will be configured later in the course
				diagnostics = "nvim_lsp",
				-- Optional, show LSP error icon
				---@diagnostic disable-next-line: unused-local
				diagnostics_indicator = function(count, level, diagnostics_dict, context)
					local s = " "
					for e, n in pairs(diagnostics_dict) do
						local sym = e == "error" and "" or (e == "warning" and "" or "")
						s = s .. n .. sym
					end
					return s
				end,
			},
		})
	end,
	keys = {
		{ "<M-1>", "<Cmd>BufferLineGoToBuffer 1<CR>", desc = "Go to " .. mode .. " 1" },
		{ "<M-2>", "<Cmd>BufferLineGoToBuffer 2<CR>", desc = "Go to " .. mode .. " 2" },
		{ "<M-3>", "<Cmd>BufferLineGoToBuffer 3<CR>", desc = "Go to " .. mode .. " 3" },
		{ "<M-4>", "<Cmd>BufferLineGoToBuffer 4<CR>", desc = "Go to " .. mode .. " 4" },
		{ "<M-5>", "<Cmd>BufferLineGoToBuffer 5<CR>", desc = "Go to " .. mode .. " 5" },
		{ "<M-6>", "<Cmd>BufferLineGoToBuffer 6<CR>", desc = "Go to " .. mode .. " 6" },
		{ "<M-7>", "<Cmd>BufferLineGoToBuffer 7<CR>", desc = "Go to " .. mode .. " 7" },
		{ "<M-8>", "<Cmd>BufferLineGoToBuffer 8<CR>", desc = "Go to " .. mode .. " 8" },
		{ "<M-9>", "<Cmd>BufferLineGoToBuffer 9<CR>", desc = "Go to " .. mode .. " 9" },

		custome.prefer_tabpage and { "<M-S-Right>", "<Cmd>+tabmove<CR>", desc = "Move tab to next" }
			or { "<M-S-Right>", "<Cmd>BufferLineMoveNext<CR>", desc = "Move buffer to next" },
		custome.prefer_tabpage and { "<M-S-Left>", "<Cmd>-tabmove<CR>", desc = "Move tab to previous" }
			or { "<M-S-Right>", "<Cmd>BufferLineMovePrev<CR>", desc = "Move buffer to previous" },

		{ "]b", "<cmd>BufferLineCycleNext<CR>", desc = util.firstToUpper(mode) },
		{ "[b", "<cmd>BufferLineCyclePrev<CR>", desc = util.firstToUpper(mode) },

		{ "<leader>bc", "<cmd>BufferLinePickClose<CR>", desc = "Close" },
		{ "<leader>bse", "<cmd>BufferLineSortByExtension<CR>", desc = "By extension" },
		{ "<leader>bsd", "<cmd>BufferLineSortByDirectory<CR>", desc = "By directory" },
		{ "<leader>bst", "<cmd>BufferLineSortByTabs<CR>", desc = "By tabs" },
	},
}
