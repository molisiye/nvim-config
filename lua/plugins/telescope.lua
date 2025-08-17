-- Build command detection
local build_cmd
for _, cmd in ipairs({ "make", "cmake", "gmake" }) do
	if vim.fn.executable(cmd) == 1 then
		build_cmd = cmd
		break
	end
end

-- Telescope picker implementation
---@class Picker
---@field name string
---@field command table<string, string>
---@field open fun(builtin: string, opts?: table)

---@type Picker
local telescope_picker = {
	name = "telescope",
	commands = {
		files = "find_files",
	},
    ---@param builtin string
    ---@param opts? table
	open = function(builtin, opts)
		opts = opts or {}
		opts.follow = opts.follow ~= false

        -- 自动检测是否在 git 仓库中
        local function is_git_repo(dir)
            return vim.fn.isdirectory(dir .. "/.git") ==1
        end

        -- 只能选择文件查找方式
        if builtin == "files" then
            local cwd = opts.cwd or vim.fn.getcwd()
            builtin = is_git_repo(cwd) and "git_files" or "find_files"
        end

        -- 处理自定义 cwd 情况
		if opts.cwd and opts.cwd ~= vim.fn.getcwd() then
			local function open_cwd_dir()
				local action_state = require("telescope.actions.state")
				local line = action_state.get_current_line()
				telescope_picker.open(
					builtin,
					vim.tbl_deep_extend("force", {}, opts or {}, {
						cwd = opts.cwd,
						default_text = line,
					})
				)
			end
			opts.attach_mappings = function(_, map)
				map("i", "<a-c>", open_cwd_dir, { desc = "Open cwd Directory" })
				return true
			end
		end
		require("telescope.builtin")[builtin](opts)
	end,
}

return {
	-- Fuzzy finder.
	-- The default key bindings to find files will use Telescope's
	-- `find_files` or `git_files` depending on whether the
	-- directory is a git repo.
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		version = false, -- telescope did only one release, so use HEAD for now
		dependencies = {
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = (build_cmd ~= "cmake") and "make"
					or "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
				enabled = build_cmd ~= nil,
				config = function(plugin)
					vim.api.nvim_create_autocmd("User", {
						pattern = "TelescopeLoaded",
						callback = function()
							local ok, err = pcall(require("telescope").load_extension, "fzf")
							if not ok then
								local lib = plugin.dir
									.. "/build/libfzf."
									.. (vim.fn.has("win32") == 1 and "dll" or "so")
								if not vim.loop.fs_stat(lib) then
									vim.notify(
										"`telescope-fzf-native.nvim` not built. Rebuilding...",
										vim.log.levels.WARN
									)
									vim.cmd("Lazy build " .. plugin.name)
								else
									vim.notify(
										"Failed to load `telescope-fzf-native.nvim`:\n" .. err,
										vim.log.levels.ERROR
									)
								end
							end
						end,
					})
				end,
			},
		},
		keys = {
			{
				"<leader>,",
				"<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
				desc = "Switch Buffer",
			},
			{
				"<leader>/",
				function()
					require("telescope.builtin").live_grep({ cwd = utils.get_root() })
				end,
				desc = "Grep (Root Dir)",
			},
			{ "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
			{
				"<leader><space>",
				function()
					telescope_picker.open("files", { cwd = utils.get_root() })
				end,
				desc = "Find Files (Root Dir)",
			},
			-- find
			{
				"<leader>fb",
				"<cmd>Telescope buffers sort_mru=true sort_lastused=true ignore_current_buffer=true<cr>",
				desc = "Buffers",
			},
			{
				"<leader>fc",
				function()
					telescope_picker.open("files", { cwd = vim.fn.stdpath("config") })
				end,
				desc = "Find Config File",
			},
			{
				"<leader>ff",
				function()
					telescope_picker.open("files", { cwd = utils.get_root() })
				end,
				desc = "Find Files (Root Dir)",
			},
			{
				"<leader>fF",
				function()
					telescope_picker.open("files", { root = false })
				end,
				desc = "Find Files (cwd)",
			},
			{ "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Find Files (git-files)" },
			{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
			{
				"<leader>fR",
				function()
					telescope_picker.open("oldfiles", { cwd = vim.uv.cwd() })
				end,
				desc = "Recent (cwd)",
			},
			-- git
			{ "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Commits" },
			{ "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Status" },
			-- search
			{ '<leader>s"', "<cmd>Telescope registers<cr>", desc = "Registers" },
			{ "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
			{ "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
			{ "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
			{ "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
			{ "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document Diagnostics" },
			{ "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace Diagnostics" },
			{
				"<leader>sg",
				function()
					telescope_picker.open("live_grep", { cwd = utils.get_root() })
				end,
				desc = "Grep (Root Dir)",
			},
			{
				"<leader>sG",
				function()
					telescope_picker.open("live_grep", { root = false })
				end,
				desc = "Grep (cwd)",
			},
			{ "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
			{ "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
			{ "<leader>sj", "<cmd>Telescope jumplist<cr>", desc = "Jumplist" },
			{ "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
			{ "<leader>sl", "<cmd>Telescope loclist<cr>", desc = "Location List" },
			{ "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
			{ "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
			{ "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
			{ "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
			{ "<leader>sq", "<cmd>Telescope quickfix<cr>", desc = "Quickfix List" },
			{
				"<leader>sw",
				function()
					telescope_picker.open("grep_string", { word_match = "-w", cwd = utils.get_root() })
				end,
				desc = "Word (Root Dir)",
			},
			{
				"<leader>sW",
				function()
					telescope_picker.open("grep_string", { word_match = "-w", cwd = vim.loop.cwd() })
				end,
				desc = "Word (cwd)",
			},
			{
				"<leader>sw",
				function()
					telescope_picker.open("grep_string", { cwd = utils.get_root() })
				end,
				mode = "v",
				desc = "Selection (Root Dir)",
			},
			{
				"<leader>sW",
				function()
					telescope_picker.open("grep_string", { cwd = vim.loop.cwd() })
				end,
				mode = "v",
				desc = "Selection (cwd)",
			},
			{
				"<leader>uC",
				function()
					telescope_picker.open("colorscheme", { enable_preview = true })
				end,
				desc = "Colorscheme with Preview",
			},
			{
				"<leader>ss",
				function()
					require("telescope.builtin").lsp_document_symbols({
						symbols = require("telescope.themes").get_ivy(),
					})
				end,
				desc = "Goto Symbol",
			},
			{
				"<leader>sS",
				function()
					require("telescope.builtin").lsp_dynamic_workspace_symbols({
						symbols = require("telescope.themes").get_ivy(),
					})
				end,
				desc = "Goto Symbol (Workspace)",
			},
		},
		opts = function()
			local actions = require("telescope.actions")

			local open_with_trouble = function(...)
				if has_plugin("trouble") then
					return require("trouble.sources.telescope").open(...)
				end
			end
			local find_files_no_ignore = function()
				local action_state = require("telescope.actions.state")
				local line = action_state.get_current_line()
				telescope_picker.open("find_files", { no_ignore = true, default_text = line, cwd = utils.get_root() })
			end
			local find_files_with_hidden = function()
				local action_state = require("telescope.actions.state")
				local line = action_state.get_current_line()
				telescope_picker.open("find_files", { hidden = true, default_text = line, cwd = utils.get_root() })
			end

			local function find_command()
				if 1 == vim.fn.executable("rg") then
					return { "rg", "--files", "--color", "never", "-g", "!.git" }
				elseif 1 == vim.fn.executable("fd") then
					return { "fd", "--type", "f", "--color", "never", "-E", ".git" }
				elseif 1 == vim.fn.executable("fdfind") then
					return { "fdfind", "--type", "f", "--color", "never", "-E", ".git" }
				elseif 1 == vim.fn.executable("find") and vim.fn.has("win32") == 0 then
					return { "find", ".", "-type", "f" }
				elseif 1 == vim.fn.executable("where") then
					return { "where", "/r", ".", "*" }
				end
			end

			return {
				defaults = {
					prompt_prefix = " ",
					selection_caret = " ",
					-- open files in the first window that is an actual file.
					-- use the current window if no other window is available.
					get_selection_window = function()
						local wins = vim.api.nvim_list_wins()
						table.insert(wins, 1, vim.api.nvim_get_current_win())
						for _, win in ipairs(wins) do
							local buf = vim.api.nvim_win_get_buf(win)
							if vim.bo[buf].buftype == "" then
								return win
							end
						end
						return 0
					end,
					mappings = {
						i = {
							["<c-t>"] = open_with_trouble,
							["<a-t>"] = open_with_trouble,
							["<a-i>"] = find_files_no_ignore,
							["<a-h>"] = find_files_with_hidden,
							["<C-Down>"] = actions.cycle_history_next,
							["<C-Up>"] = actions.cycle_history_prev,
							["<C-f>"] = actions.preview_scrolling_down,
							["<C-b>"] = actions.preview_scrolling_up,
						},
						n = {
							["q"] = actions.close,
						},
					},
				},
				pickers = {
					find_files = {
						find_command = find_command,
						hidden = true,
					},
				},
			}
		end,
	},

	-- Flash Telescope config
	{
		"nvim-telescope/telescope.nvim",
		optional = true,
		opts = function(_, opts)
			if utils.has_plugin("flash.nvim") then
				return
			end
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
						picker:set_selection(match.pos[1] - 1)
					end,
				})
			end
			opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
				mappings = { n = { s = flash }, i = { ["<c-s>"] = flash } },
			})
		end,
	},

	-- better vim.ui with telescope
	{
		"stevearc/dressing.nvim",
		lazy = true,
		init = function()
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.select = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.select(...)
			end
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.input = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.input(...)
			end
		end,
	},
}
