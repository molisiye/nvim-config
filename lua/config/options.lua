local opt = vim.opt
local o = vim.o
local g = vim.g

opt.backup = false -- creates a backup file
opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
opt.cmdheight = 0 -- more space in the neovim command line for displaying messages
-- o.completeopt = { "menuone","noselect" } -- mostly just for cmp
opt.conceallevel = 0 -- so that `` is visible in markdown files
opt.fileencoding = "utf-8" -- the encoding written to a file
opt.hlsearch = true-- highlight all matches on previous search pattern
opt.ignorecase = true-- ignore case in search patterns
opt.mouse = "a"-- allow the mouse to be used in neovim
opt.pumheight = 10-- pop up menu height
opt.showmode = false-- we don't need to see things like -- INSERT -- anymore
opt.showtabline = 2-- always show tabs
opt.smartcase = true-- smart case
opt.smartindent = true-- make indenting smarter again
opt.splitbelow = true-- force all horizontal splits to go below current window
opt.splitright = true-- force all vertical splits to go to the right of current window
opt.swapfile = false-- creates a swapfile
-- termguicolors = true                   -- set term gui colors (most terminals support this)
opt.timeoutlen = 300-- time to wait for a mapped sequence to complete (in milliseconds)
opt.undofile = true-- enable persistent undo
opt.updatetime = 300-- faster completion (4000ms default)
opt.writebackup = false-- if a file is being edited by another program (or was written to file while editing with another program)it is not allowed to be edited
opt.expandtab = true-- convert tabs to spaces
opt.shiftwidth = 4-- the number of spaces inserted for each indentation
opt.tabstop = 4-- insert 4 spaces for a tab
opt.cursorline = true-- highlight the current line
opt.number = true-- set numbered lines
opt.relativenumber = true-- set relative numbered lines
opt.numberwidth = 4-- set number column width to 2 {default 4}
opt.signcolumn = "yes"-- always show the sign columnotherwise it would shift the text each time
opt.wrap = true-- display lines as one long line
opt.linebreak = true-- companion to wrapdon't split words
opt.scrolloff = 8-- minimal number of screen lines to keep above and below the cursor
opt.sidescrolloff = 8-- minimal number of screen columns either side of cursor if wrap is `false`
-- guifont = "Iosevka_Nerd_Font_Mono:h17"              -- the font used in graphical neovim applications opt.whichwrap = "bs<>[]hl"-- which "horizontal" keys are allowed to travel to prev/next line

-- local options = {
--
-- 	backup = false-- creates a backup file
-- 	clipboard = "unnamedplus"-- allows neovim to access the system clipboard
-- 	cmdheight = 0-- more space in the neovim command line for displaying messages
-- 	completeopt = { "menuone""noselect" }-- mostly just for cmp
-- 	conceallevel = 0-- so that `` is visible in markdown files
-- 	fileencoding = "utf-8"-- the encoding written to a file
-- 	hlsearch = true-- highlight all matches on previous search pattern
-- 	ignorecase = true-- ignore case in search patterns
-- 	mouse = "a"-- allow the mouse to be used in neovim
-- 	pumheight = 10-- pop up menu height
-- 	showmode = false-- we don't need to see things like -- INSERT -- anymore
-- 	showtabline = 2-- always show tabs
-- 	smartcase = true-- smart case
-- 	smartindent = true-- make indenting smarter again
-- 	splitbelow = true-- force all horizontal splits to go below current window
-- 	splitright = true-- force all vertical splits to go to the right of current window
-- 	swapfile = false-- creates a swapfile
-- 	-- termguicolors = true                   -- set term gui colors (most terminals support this)
-- 	timeoutlen = 300-- time to wait for a mapped sequence to complete (in milliseconds)
-- 	undofile = true-- enable persistent undo
-- 	updatetime = 300-- faster completion (4000ms default)
-- 	writebackup = false-- if a file is being edited by another program (or was written to file while editing with another program)it is not allowed to be edited
-- 	expandtab = true-- convert tabs to spaces
-- 	shiftwidth = 4-- the number of spaces inserted for each indentation
-- 	tabstop = 4-- insert 4 spaces for a tab
-- 	cursorline = true-- highlight the current line
-- 	number = true-- set numbered lines
-- 	relativenumber = true-- set relative numbered lines
-- 	numberwidth = 4-- set number column width to 2 {default 4}
--
-- 	signcolumn = "yes"-- always show the sign columnotherwise it would shift the text each time
-- 	wrap = true-- display lines as one long line
-- 	linebreak = true-- companion to wrapdon't split words
-- 	scrolloff = 8-- minimal number of screen lines to keep above and below the cursor
-- 	sidescrolloff = 8-- minimal number of screen columns either side of cursor if wrap is `false`
-- 	-- guifont = "Iosevka_Nerd_Font_Mono:h17"              -- the font used in graphical neovim applications
-- 	whichwrap = "bs<>[]hl"-- which "horizontal" keys are allowed to travel to prev/next line
-- }
--
-- for kv in pairs(options) do
-- 	vim.opt[k] = v
-- end

--Remap space as leader key
--keymap("""<Space>""<Nop>")
g.mapleader = ' '
g.maplocalleader = " "

-- vim.opt.shortmess = "ilmnrx"                        -- flags to shorten vim messagessee :help 'shortmess'
opt.shortmess:append("c") -- don't give |ins-completion-menu| messages
opt.iskeyword:append("-") -- hyphenated words recognized by searches
-- opt.formatoptions:remove({ "c""r""o" }) -- don't insert the current comment leader automatically for auto-wrapping comments using 'textwidth'hitting <Enter> in insert modeor hitting 'o' or 'O' in normal mode.
opt.runtimepath:remove("/usr/share/vim/vimfiles") -- separate vim plugins from neovim in case vim still in use
