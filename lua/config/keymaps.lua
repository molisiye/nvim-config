local keymap = utils.keymap

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
keymap({ "n", "i", "x", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save" })
keymap("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h")
keymap("n", "<C-j>", "<C-w>j")
keymap("n", "<C-k>", "<C-w>k")
keymap("n", "<C-l>", "<C-w>l")

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>")
keymap("n", "<C-Down>", ":resize +2<CR>")
keymap("n", "<C-Left>", ":vertical resize -2<CR>")
keymap("n", "<C-Right>", ":vertical resize +2<CR>")

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>")
keymap("n", "<S-h>", ":bprevious<CR>")

-- Move text up and down
keymap("n", "<A-j>", "<Esc>:m .+1<CR>==gi")
keymap("n", "<A-k>", "<Esc>:m .-2<CR>==gi")

-- Insert --
-- Press jk fast to exit insert mode
keymap("i", "jk", "<ESC>")
keymap("i", "kj", "<ESC>")

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

-- Move text up and down
keymap("v", "<A-k>", ":m .-2<CR>==")
keymap("v", "<A-j>", ":m .+1<CR>==")
-- keymap("v", "p", '"_dP')

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv")
keymap("x", "K", ":move '<-2<CR>gv-gv")
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv")
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv")

-- mason
keymap("n", "<leader>mm", "<Cmd>Mason<CR>", { desc = "Packages" })

-- telescope
keymap("n", "<leader>fb", function()
	require("telescope.builtin").buffers()
end, { desc = "Buffers" })

keymap("n", "<leader>ff", function()
	require("telescope.builtin").find_files()
end, { desc = "Files" })

keymap("n", "<leader>f?", function()
	require("telescope.builtin").help_tags()
end, { desc = "Help tags" })

keymap("n", "<leader>fh", function()
	require("telescope.builtin").oldfiles()
end, { desc = "Old files" })

keymap("n", "<leader>fm", function()
	require("telescope.builtin").marks()
end, { desc = "Marks" })

keymap("n", "<leader>fs", function()
	require("telescope.builtin").lsp_document_symbols()
end, { desc = "Symbols" })

keymap("n", "<leader>fS", function()
	require("telescope.builtin").lsp_workspace_symbols()
end, { desc = "Workspace symbols" })

keymap("n", "<leader>fc", function()
	require("telescope.builtin").colorscheme()
end, { desc = "Colorscheme" })

keymap("n", "<leader>fg", function()
	require("telescope.builtin").extensions.live_grep_args.live_grep_args()
end, { desc = "Live grep" })

keymap("n", "<leader>fn", function()
	require("telescope.builtin").extensions.notify.notify()
end, { desc = "Notify" })

keymap("n", "<leader>fW", function()
	require("telescope.builtin").live_grep({
		additional_args = { "--hidden", "--no-ignore" }
	})
end, { desc = "Find words in all files" })

keymap("n", "<leader>fw", function()
	require("telescope.builtin").live_grep()
end, { desc = "Find words" })

-- aerial
keymap("n", "<leader>a", "<Cmd>AerialToggle<CR>", { desc = "Outline" })

-- neotree
keymap("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "File Explorer" })

-- conform
keymap("n", "<leader>F", function()
	require("conform").format({ lsp_fallback = true })
end, { desc = "Format Document" })

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
keymap("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
keymap("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
keymap("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
keymap("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
keymap("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
keymap("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
keymap("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- dap
keymap("n", "<F5>", function()
	require("dap").continue() 
end, { desc = "Debug: Continue" })

keymap("n", "<F10>", function()
	require("dap").step_over()
end, { desc = "Debug: Step over" })

keymap("n", "<F11>", function()
	require("dap").step_into()
end, { desc = "Debug: Step into" })

keymap("n", "<F12>", function()
	require("dap").step_out()
end, { desc = "Debug: Step out" })

keymap("n", "<F9>", function()
	require("dap").toggle_breakpoint()
end, { desc = "Debug: Toggle breakpoint" })

keymap("n", "<leader>db", function()
	require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Set breakpoint" })

keymap("n", "<leader>dp", function()
	require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end, { desc = "Set log point" })

keymap("n", "<leader>dr", function()
	require("dap").repl.toggle()
end, { desc = "Toggle REPL" })

keymap("n", "<leader>dl", function()
	require("dap").run_last()
end, { desc = "Run last" })

-- dap-python
keymap("n", "<leader>dn", function()
	require("dap-python").test_method()
end, { desc = "Test method" })

keymap("n", "<leader>df", function()
	require("dap-python").test_class()
end, { desc = "Test class" })

keymap("v", "<leader>ds", function()
	require("dap-python").debug_selection()
end, { desc = "Debug selection" })

-- dap-ui
keymap("n", "<leader>du", function()
	require("dapui").toggle()
end, { desc = "Toggle UI" })

-- Terminal --
-- Better terminal navigation
-- keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
-- keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
-- keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
-- keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)
