return function()
	local gs = require("gitsigns")
	local custome = require("custome")

	gs.setup({
		word_diff = true,
		preview_config = {
			border = custome.border,
		},
		on_attach = function(bufnr)
			-- Navigation
			vim.keymap.set("n", "]h", function()
				if vim.wo.diff then
					return "]h"
				end
				vim.schedule(function()
					gs.next_hunk()
				end)
				return "<Ignore>"
			end, { buffer = bufnr, expr = true, desc = "Next hunk" })

			vim.keymap.set("n", "[h", function()
				if vim.wo.diff then
					return "[h"
				end
				vim.schedule(function()
					gs.prev_hunk()
				end)
				return "<Ignore>"
			end, { buffer = bufnr, expr = true, desc = "Previous hunk" })

			-- Actions
			vim.keymap.set("n", "<leader>gs", gs.stage_hunk, { buffer = bufnr, desc = "Stage hunk" })
			vim.keymap.set("v", "<leader>gs", function()
				gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { buffer = bufnr, desc = "Stage hunk" })
			vim.keymap.set("n", "<leader>gr", gs.reset_hunk, { buffer = bufnr, desc = "Reset hunk" })
			vim.keymap.set("v", "<leader>gr", function()
				gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { buffer = bufnr, desc = "Reset hunk" })
			vim.keymap.set("n", "<leader>gu", gs.undo_stage_hunk, { buffer = bufnr, desc = "Undo stage hunk" })
			vim.keymap.set("n", "<leader>gS", gs.stage_buffer, { buffer = bufnr, desc = "Stage buffer" })
			vim.keymap.set("n", "<leader>gR", gs.reset_buffer, { buffer = bufnr, desc = "Reset buffer" })
			vim.keymap.set("n", "<leader>gp", gs.preview_hunk, { buffer = bufnr, desc = "Preview hunk" })
			vim.keymap.set("n", "<leader>gb", function()
				gs.blame_line({ full = true })
			end, { buffer = bufnr, desc = "Blame line" })

			vim.keymap.set("n", "<leader>td", gs.toggle_deleted, { buffer = bufnr, desc = "Deleted" })
			vim.keymap.set("n", "<leader>tb", gs.toggle_current_line_blame, { buffer = bufnr, desc = "Line Blame" })

			-- Text object
			vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
			vim.keymap.set({ "o", "x" }, "ah", ":<C-U>Gitsigns select_hunk<CR>")
		end,
	})

	local function set_hl()
		vim.api.nvim_set_hl(0, "GitSignsChangeLn", { link = "DiffText" })
		vim.api.nvim_set_hl(0, "GitSignsDeleteLn", { link = "DiffDelete" })

		vim.api.nvim_set_hl(0, "GitSignsAddInline", { link = "GitSignsAddLn" })
		vim.api.nvim_set_hl(0, "GitSignsDeleteInline", { link = "GitSignsDeleteLn" })
		vim.api.nvim_set_hl(0, "GitSignsChangeInline", { link = "GitSignsChangeLn" })
	end

	set_hl()

	vim.api.nvim_create_autocmd("ColorScheme", {
		desc = "Set gitsigns highlights",
		callback = set_hl,
	})
end
