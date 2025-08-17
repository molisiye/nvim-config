local custom = require("config.custom")
local lazy_status = require("lazy.status")

local function indent()
	if vim.o.expandtab then
		return "SW:" .. vim.o.shiftwidth
	else
		return "TS:" .. vim.o.tabstop
	end
end

local function lsp()
	local clients = vim.lsp.get_clients()
	local buf = vim.api.nvim_get_current_buf()
	clients = vim.iter(clients)
		:filter(function(client)
			return client.attached_buffers[buf]
		end)
		:filter(function(client)
			return client.name ~= "GitHub Copilot"
		end)
		:map(function(client)
			return " " .. client.name
		end)
		:totable()
	local info = table.concat(clients, " ")
	if info == "" then
		return "No attached LSP server"
	else
		return info
	end
end

local function dap()
	---@diagnostic disable-next-line: redefined-local
	local dap = package.loaded["dap"]
	if dap then
		return dap.status()
	end
	return ""
end

local function osv()
	---@diagnostic disable-next-line: redefined-local
	local osv = package.loaded["osv"]
	if osv and osv.is_running() then
		return "Running as debuggee"
	end
	return ""
end

local function dap_or_lsp()
	if osv() ~= "" then
		return osv()
	elseif dap() ~= "" then
		return dap()
	else
		return lsp()
	end
end

return {
	{
		"nvim-lualine/lualine.nvim",
		init = function()
			vim.o.laststatus = 0
		end,
		event = "VeryLazy",
		dependencies = {
			{ "nvim-tree/nvim-web-devicons" },
			{ "ofseed/copilot-status.nvim", enabled = false },
		},
		opts = {
			sections = {
				lualine_a = {
					{
						"mode",
						icon = "",
					},
				},
				lualine_b = {
					{
						"branch",
						icon = "",
					},
					{
						"diff",
						symbols = {
							added = " ",
							modified = " ",
							removed = " ",
						},
						source = function()
							return vim.b.gitsigns_status_dict
						end,
					},
				},
				lualine_c = {
					dap_or_lsp,
				},
				lualine_x = {
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
						color = { fg = "#ff9e64" },
					},
					{
						name = "overseer-placeholder",
						function()
							return ""
						end,
					},
					"copilot",
					indent,
					{
						"encoding",
						show_bomb = true,
					},
					"fileformat",
				},
				lualine_y = {
					"diagnostics",
					{
						"progress",
						icon = "",
					},
				},
				lualine_z = {
					{
						"location",
						icon = "",
					},
				},
			},
			options = {
				icons_enabled = true,
				theme = "auto",
				disabled_filetypes = {
					statusline = {
						"alpha",
					},
				},
				always_divide_middle = true,
				globalstatus = false,
				section_separators = { left = "", right = "" },
				component_separators = { left = "", right = "" },
			},
			extensions = {
				"man",
				"quickfix",
				"nvim-tree",
				"neo-tree",
				"toggleterm",
				"symbols-outline",
				"aerial",
				"fugitive",
				"nvim-dap-ui",
				"mundo",
				"lazy",
			},
		},
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		event = "VeryLazy",
		opts = {
			indent = {
				char = "▏", -- Thiner, not suitable when enable scope
				tab_char = "▏",
			},
			debounce = 50,
			scope = { enabled = true },
		},
		config = function(_, opts)
			local ibl = require("ibl")
			local hooks = require("ibl.hooks")

			ibl.setup(opts)

			-- Hide first level indent, using `foldsep` to show it
			-- hooks.register(hooks.type.ACTIVE, function(_)
			-- local unuse = { "oil" } -- filetype that should not use indent-blankline
			-- return not vim.tbl_contains(unuse, vim.bo.filetype)
			-- end)
			hooks.register(hooks.type.VIRTUAL_TEXT, function(_, bufnr, row, virt_text)
				local win = vim.fn.bufwinid(bufnr)
				local lnum = row + 1
				local foldinfo = utils.fold_info(win, lnum)

				if virt_text[1] and virt_text[1][1] == opts.indent.char and foldinfo and foldinfo.start == lnum then
					virt_text[1] = { " ", { "@ibl.whitespace.char.1" } }
				end

				return virt_text
			end)
		end,
	},
	{
		"hiphish/rainbow-delimiters.nvim",
		event = "VeryLazy",
		config = function()
			local rainbow_delimiters = require("rainbow-delimiters")
			require("rainbow-delimiters.setup").setup({
				strategy = {
					[""] = rainbow_delimiters.strategy["global"],
					vim = rainbow_delimiters.strategy["local"],
				},
				query = {
					[""] = "rainbow-delimiters",
					lua = "rainbow-blocks",
				},
				priority = {
					[""] = 110,
					lua = 210,
				},
				highlight = {
					"RainbowDelimiterRed",
					"RainbowDelimiterYellow",
					"RainbowDelimiterBlue",
					"RainbowDelimiterOrange",
					"RainbowDelimiterGreen",
					"RainbowDelimiterViolet",
					"RainbowDelimiterCyan",
				},
			})
		end,
	},
	{
		"stevearc/quicker.nvim",
		ft = "qf",
		---@module "quicker"
		---@type quicker.SetupOptions
		opts = {
			number = true,
			highlight = {
				lsp = false,
			},
			max_filename_width = function()
				return math.floor(math.min(60, vim.o.columns / 4))
			end,
		},
		keys = {
			{
				"<leader>xq",
				function()
					require("quicker").toggle({ open_cmd_mods = { split = "botright" } })
				end,
				desc = "Toggle [Q]uickfix",
			},
			{
				"<leader>xl",
				function()
					require("quicker").toggle({ loclist = true })
				end,
				desc = "Toggle [L]oclist",
			},
			{
				"<leader>xQ",
				function()
					vim.fn.setqflist({}, "a", {
						items = {
							{
								bufnr = vim.api.nvim_get_current_buf(),
								lnum = vim.api.nvim_win_get_cursor(0)[1],
								text = vim.api.nvim_get_current_line(),
							},
						},
					})
				end,
				desc = "Add to [Q]uickfix",
			},
		},
	},
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		init = function()
			vim.o.showtabline = 2
			vim.o.tabline = " "
		end,
		opts = {
			options = {
				mode = "buffers",
			},
		},
		keys = {
			{
				"<leader>1",
				"<Cmd>BufferLineGoToBuffer 1<CR>",
				desc = "Go to tab 1",
			},
			{
				"<leader>2",
				"<Cmd>BufferLineGoToBuffer 2<CR>",
				desc = "Go to tab 2",
			},
			{
				"<leader>3",
				"<Cmd>BufferLineGoToBuffer 3<CR>",
				desc = "Go to tab 3",
			},
			{
				"<leader>4",
				"<Cmd>BufferLineGoToBuffer 4<CR>",
				desc = "Go to tab 4",
			},
			{
				"<leader>5",
				"<Cmd>BufferLineGoToBuffer 5<CR>",
				desc = "Go to tab 5",
			},
			{
				"<leader>6",
				"<Cmd>BufferLineGoToBuffer 6<CR>",
				desc = "Go to tab 6",
			},
			{
				"<leader>7",
				"<Cmd>BufferLineGoToBuffer 7<CR>",
				desc = "Go to tab 7",
			},
			{
				"<leader>8",
				"<Cmd>BufferLineGoToBuffer 8<CR>",
				desc = "Go to tab 8",
			},
			{
				"<leader>9",
				"<Cmd>BufferLineGoToBuffer 9<CR>",
				desc = "Go to tab 9",
			},

			{ "<M-S-Right>", "<Cmd>+tabmove<CR>", desc = "Move tab to next" },
			{ "<M-S-Left>", "<Cmd>-tabmove<CR>", desc = "Move tab to previous" },

			{ "<leader>bc", "<cmd>BufferLinePickClose<CR>", desc = "Close" },
			{
				"<leader>bse",
				"<cmd>BufferLineSortByExtension<CR>",
				desc = "By extension",
			},
			{
				"<leader>bsd",
				"<cmd>BufferLineSortByDirectory<CR>",
				desc = "By directory",
			},
			{ "<leader>bst", "<cmd>BufferLineSortByTabs<CR>", desc = "By tabs" },
			{ "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
			{ "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
			{ "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
			{ "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
			{ "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
			{ "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
			{ "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
			{ "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
			{ "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
			{ "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
		},
		config = function(_, opts)
			require("bufferline").setup(opts)
		end,
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			routes = {
				{
					filter = {
						event = "msg_show",
						any = {
							{ find = "%d+L, %d+B" },
							{ find = "; after #%d+" },
							{ find = "; before #%d+" },
						},
					},
					view = "mini",
				},
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
			},
		},
    -- stylua: ignore
    keys = {
      { "<leader>sn", "", desc = "+noice"},
      { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
      { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
      { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
      { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
      { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
      { "<leader>snt", function() require("noice").cmd("pick") end, desc = "Noice Picker (Telescope/FzfLua)" },
      { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll Forward", mode = {"i", "n", "s"} },
      { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll Backward", mode = {"i", "n", "s"}},
    },
		config = function(_, opts)
			-- HACK: noice shows messages from before it was enabled,
			-- but this is not ideal when Lazy is installing plugins,
			-- so clear the messages in this case.
			if vim.o.filetype == "lazy" then
				vim.cmd([[messages clear]])
			end
			require("noice").setup(opts)
		end,
	},
	-- icons
	{
		"echasnovski/mini.icons",
		lazy = true,
		opts = {
			file = {
				[".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
				["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
			},
			filetype = {
				dotenv = { glyph = "", hl = "MiniIconsYellow" },
			},
		},
		init = function()
			package.preload["nvim-web-devicons"] = function()
				require("mini.icons").mock_nvim_web_devicons()
				return package.loaded["nvim-web-devicons"]
			end
		end,
	},
	-- edgy
	{
		"folke/edgy.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<leader>ue",
				function()
					require("edgy").toggle()
				end,
				desc = "Edgy Toggle",
			},
      -- stylua: ignore
      { "<leader>uE", function() require("edgy").select() end, desc = "Edgy Select Window" },
		},
		opts = function()
			local opts = {
				bottom = {
					{
						ft = "toggleterm",
						size = { height = 0.4 },
						filter = function(buf, win)
							return vim.api.nvim_win_get_config(win).relative == ""
						end,
					},
					{
						ft = "noice",
						size = { height = 0.4 },
						filter = function(buf, win)
							return vim.api.nvim_win_get_config(win).relative == ""
						end,
					},
					"Trouble",
					{ ft = "qf", title = "QuickFix" },
					{
						ft = "help",
						size = { height = 20 },
						-- don't open help files in edgy that we're editing
						filter = function(buf)
							return vim.bo[buf].buftype == "help"
						end,
					},
					{ title = "Spectre", ft = "spectre_panel", size = { height = 0.4 } },
					{ title = "Neotest Output", ft = "neotest-output-panel", size = { height = 15 } },
				},
				left = {
					{ title = "Neotest Summary", ft = "neotest-summary" },
					-- "neo-tree",
				},
				right = {
					{ title = "Grug Far", ft = "grug-far", size = { width = 0.4 } },
				},
				keys = {
					-- increase width
					["<c-Right>"] = function(win)
						win:resize("width", 2)
					end,
					-- decrease width
					["<c-Left>"] = function(win)
						win:resize("width", -2)
					end,
					-- increase height
					["<c-Up>"] = function(win)
						win:resize("height", 2)
					end,
					-- decrease height
					["<c-Down>"] = function(win)
						win:resize("height", -2)
					end,
				},
			}

			-- 检测插件是否安装
			local function has_plugin(name)
				local ok, _ = pcall(require, name)
				return ok
			end

			if has_plugin("neo-tree.nvim") then
				local pos = {
					filesystem = "left",
					buffers = "top",
					git_status = "right",
					document_symbols = "bottom",
					diagnostics = "bottom",
				}
				-- 获取 neo-tree 的配置（如果没有配置，则使用默认 souces）
				local neotree_config = require("neo-tree").config or {}
				local sources = neotree_config.sources or { "filesystem", "buffers", "git_status" }

				for i, v in ipairs(sources) do
					table.insert(opts.left, i, {
						title = "Neo-Tree " .. v:gsub("_", " "):gsub("^%l", string.upper),
						ft = "neo-tree",
						filter = function(buf)
							return vim.b[buf].neo_tree_source == v
						end,
						pinned = true,
						open = function()
							vim.cmd(
								("Neotree show position=%s %s dir=%s"):format(pos[v] or "bottom", v, vim.fn.getcwd())
							)
						end,
					})
				end
			end

			return opts
		end,
	},

	-- use edgy's selection window
	{
		"nvim-telescope/telescope.nvim",
		optional = true,
		opts = {
			defaults = {
				get_selection_window = function()
					require("edgy").goto_main()
					return 0
				end,
			},
		},
	},

	-- ui components
	{ "MunifTanjim/nui.nvim", lazy = true },
	-- ufo folding{
	{
		"kevinhwang91/nvim-ufo",
		cond = function()
			if vim.lsp._folding_range then
				vim.o.foldmethod = "expr"
				vim.o.foldexpr = "v:lua.vim.lsp.foldexpr()"
				vim.o.foldtext = "v:lua.vim.lsp.foldtext()"
				vim.o.foldcolumn = "1"
				vim.o.foldlevel = 99

				vim.api.nvim_create_autocmd("LspNotify", {
					callback = function(args)
						if args.data.method == "textDocument/didOpen" then
							vim.lsp.foldclose("imports", vim.fn.bufwinid(args.buf))
						end
					end,
				})
				return false
			end
			return true
		end,
		event = "VeryLazy",
		dependencies = "kevinhwang91/promise-async",
		init = function()
			local set_foldcolumn_for_file = vim.api.nvim_create_augroup("set_foldcolumn_for_file", {
				clear = true,
			})
			vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
				group = set_foldcolumn_for_file,
				callback = function()
					if vim.bo.buftype == "" then
						vim.wo.foldcolumn = "1"
					else
						vim.wo.foldcolumn = "0"
					end
				end,
			})
			vim.api.nvim_create_autocmd("OptionSet", {
				group = set_foldcolumn_for_file,
				pattern = "buftype",
				callback = function()
					if vim.bo.buftype == "" then
						vim.wo.foldcolumn = "1"
					else
						vim.wo.foldcolumn = "0"
					end
				end,
			})
			vim.o.foldlevel = 99
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true
		end,
		opts = {
			close_fold_kinds_for_ft = {
				default = { "imports" },
			},
		},
		config = function(_, opts)
			local ufo = require("ufo")
			ufo.setup(opts)

			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "Setup Ufo `K` with LSP hover",
				callback = function(args)
					local bufnr = args.buf

					vim.keymap.set("n", "K", function()
						local winid = ufo.peekFoldedLinesUnderCursor()
						if not winid then
							vim.lsp.buf.hover()
						end
					end, { buffer = bufnr, desc = "LSP: Signature help" })
				end,
			})
		end,
	},
	{
		"goolord/alpha-nvim",
		event = "VimEnter",
		config = function()
			local dashboard = require("alpha.themes.dashboard")
			dashboard.section.header.val = {
				[[ ███▄    █ ▓█████  ▒█████   ██▒   █▓ ██▓ ███▄ ▄███▓]],
				[[ ██ ▀█   █ ▓█   ▀ ▒██▒  ██▒▓██░   █▒▓██▒▓██▒▀█▀ ██▒]],
				[[▓██  ▀█ ██▒▒███   ▒██░  ██▒ ▓██  █▒░▒██▒▓██    ▓██░]],
				[[▓██▒  ▐▌██▒▒▓█  ▄ ▒██   ██░  ▒██ █░░░██░▒██    ▒██ ]],
				[[▒██░   ▓██░░▒████▒░ ████▓▒░   ▒▀█░  ░██░▒██▒   ░██▒]],
				[[░ ▒░   ▒ ▒ ░░ ▒░ ░░ ▒░▒░▒░    ░ ▐░  ░▓  ░ ▒░   ░  ░]],
				[[░ ░░   ░ ▒░ ░ ░  ░  ░ ▒ ▒░    ░ ░░   ▒ ░░  ░      ░]],
				[[   ░   ░ ░    ░   ░ ░ ░ ▒       ░░   ▒ ░░      ░   ]],
				[[         ░    ░  ░    ░ ░        ░   ░         ░   ]],
				[[                                ░                  ]],
			}
			dashboard.section.buttons.val = {
				dashboard.button("f", "󰈞  Find file", ":Telescope find_files <CR>"),
				dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
				dashboard.button("p", "  Find project", ":Telescope projects <CR>"),
				dashboard.button("r", "󰄉  Recently used files", ":Telescope oldfiles <CR>"),
				dashboard.button("t", "󰊄  Find text", ":Telescope live_grep <CR>"),
				dashboard.button("c", "  Configuration", ":e $MYVIMRC <CR>"),
				dashboard.button("q", "󰅚  Quit Neovim", ":qa<CR>"),
			}

			local function footer()
				local stats = require("lazy").stats()
				--local ms = (math.floor(stats.startuptime* 100 + 0.5)/100)
				return stats.count .. " plugins is loaded."
			end

			dashboard.section.footer.val = footer()

			dashboard.section.footer.opts.hl = "Type"
			dashboard.section.header.opts.hl = "Include"
			dashboard.section.buttons.opts.hl = "Keyword"

			dashboard.opts.opts.noautocmd = true
			require("alpha").setup(dashboard.opts)
		end,
	},

	{
		"stevearc/dressing.nvim",
		event = "VeryLazy",
		opts = {
			input = {
				border = custom.border,
			},
			select = {
				builtin = {
					border = custom.border,
				},
			},
		},
	},
	{
		"Bekaboo/dropbar.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			bar = {
				enable = function(buf, win)
					return not vim.api.nvim_win_get_config(win).zindex
						and vim.bo[buf].buftype == ""
						and vim.api.nvim_buf_get_name(buf) ~= ""
						and not vim.wo[win].diff
						and vim.bo[buf].filetype ~= "toggleterm"
				end,
			},
		},
	},
	---@type LazyPluginSpec
	{
		"onsails/lspkind.nvim",
		lazy = true,
		opts = {
			symbol_map = custom.icons.kind,
		},
	},
}
