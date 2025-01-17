return {
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
			-- NOTE: requires the fortune-mod package to work
			-- local handle = io.popen("fortune")
			-- local fortune = handle:read("*a")
			-- handle:close()
			-- return fortune
			--return "chrisatmachine.com"
			local stats = require("lazy").stats()
			--local ms = (math.floor(stats.startuptime* 100 + 0.5)/100)
			return stats.count .. " plugins is loaded."
		end

		dashboard.section.footer.val = footer()

		dashboard.section.footer.opts.hl = "Type"
		dashboard.section.header.opts.hl = "Include"
		dashboard.section.buttons.opts.hl = "Keyword"

		dashboard.opts.opts.noautocmd = true
		-- vim.cmd([[autocmd User AlphaReady echo 'ready']])
		require("alpha").setup(dashboard.opts)
	end,
}
