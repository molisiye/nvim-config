return {
	-- lsp for cargo.toml
	{
		"Saecki/crates.nvim",
		event = { "BufRead Cargo.toml" },
		opts = {
			completion = {
				crates = {
					enabled = true,
				},
			},
			lsp = {
				enabled = true,
				actions = true,
				completion = true,
				hover = true,
			},
		},
	},
	{
		"mrcjkb/rustaceanvim",
		version = vim.fn.has("nvim-0.10.0") == 0 and "^4" or false,
		ft = { "rust" },
		opts = {
			server = {
				on_attach = function(_, bufnr)
					vim.keymap.set("n", "<leader>cR", function()
						vim.cmd.RustLsp("codeAction")
					end, { desc = "Code Action", buffer = bufnr })
					vim.keymap.set("n", "<leader>dr", function()
						vim.cmd.RustLsp("debuggables")
					end, { desc = "Rust Debuggables", buffer = bufnr })
				end,
				default_settings = {
					-- rust-analyzer language server configuration
					["rust-analyzer"] = {
						cargo = {
							allFeatures = true,
							loadOutDirsFromCheck = true,
							buildScripts = {
								enable = true,
							},
						},
						-- Add clippy lints for Rust if using rust-analyzer
						checkOnSave = true,
						-- Enable diagnostics if using rust-analyzer
						diagnostics = {
							enable = true,
						},
                        inlayHints = {
                            bindingModeHints = {eanble = true},
                            lifetimeElisionHints = {
                                enable = true,
                                useParameterNames = true
                            }
                        },
						procMacro = {
							enable = true,
							ignored = {
								["async-trait"] = { "async_trait" },
								["napi-derive"] = { "napi" },
								["async-recursion"] = { "async_recursion" },
							},
						},
						files = {
							excludeDirs = {
								".direnv",
								".git",
								".github",
								".gitlab",
								"bin",
								"node_modules",
								"target",
								"venv",
								".venv",
							},
						},
                        standalone = true,
                        cmd = {"rustup", "run", "stable", "rust-analyzer"}
					},
				},
			},
		},
		config = function(_, opts)
			-- if LazyVim.has("mason.nvim") then
			local package_path = require("mason-registry").get_package("codelldb"):get_install_path()
			local codelldb = package_path .. "/extension/adapter/codelldb"
			local library_path = package_path .. "/extension/lldb/lib/liblldb.dylib"
			local uname = io.popen("uname"):read("*l")
			if uname == "Linux" then
				library_path = package_path .. "/extension/lldb/lib/liblldb.so"
			end
			opts.dap = {
				adapter = require("rustaceanvim.config").get_codelldb_adapter(codelldb, library_path),
			}
			-- end
			vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
			-- if vim.fn.executable("rust-analyzer") == 0 then
			-- 	LazyVim.error(
			-- 		"**rust-analyzer** not found in PATH, please install it.\nhttps://rust-analyzer.github.io/",
			-- 		{ title = "rustaceanvim" }
			-- 	)
			-- end
		end,
	},
	{
		"folke/lazydev.nvim",
		ft = "lua",
		cmd = "LazyDev",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				{ path = "lazy.nvim", words = { "Lazy.*Spec", "LazyVim" } },
			},
			-- enabled = function(root_dir)
			-- 	if vim.g.lazydev_enabled == false then
			-- 		return false
			-- 	end
			--
			-- 	-- Disable if .luarc.json exists and workspace.library is set
			-- 	local fd = vim.uv.fs_open(root_dir .. "/.luarc.json", "r", 438)
			-- 	if fd then
			-- 		local luarc = vim.json.decode(assert(vim.uv.fs_read(fd, vim.uv.fs_fstat(fd).size)))
			-- 		return not (luarc.workspace and luarc.workspace.library)
			-- 	end
			-- 	return true
			-- end,
		},
	},
}
