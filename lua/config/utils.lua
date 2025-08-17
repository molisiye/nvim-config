local M = {}

_G.utils = M

-- 检查插件是否加载
function M.has_plugin(name)
	local ok, _ = pcall(require, name)
	return ok
end

function M.init()
    vim.print("test")
end

-- 获取项目根目录
function M.get_root()
	local root_patterns = { ".git", "lua", "Makefile" }
	for _, pattern in ipairs(root_patterns) do
		local root = vim.fs.dirname(vim.fs.find(pattern, { upward = true })[1])
		if root then
			return root
		end
	end
	return vim.uv.cwd()
end

function M.keymap(mode, lhs, rhs, opt)
	vim.keymap.set(mode, lhs, rhs, opt)
end

function M.get_install_path(pkgname)
    return vim.fn.expand("$MASON/packages/" .. pkgname)
end


-- copy from astronvim
function M.empty_map_table()
	local maps = {}
	for _, mode in ipairs({ "", "n", "v", "x" }) do
		maps[mode] = {}
	end
	return maps
end

-- copy from astronvim
function M.set_mapping(map_table, base)
	base = base or {}
	for mode, maps in pairs(map_table) do
		for keymap, opt in pairs(maps) do
			if opt then
				local cmd = opt
				local keymap_opt = base
				if type(opt) == "table" then
					cmd = opt[1]
					keymap_opt = vim.tbl_deep_extend("force", keymap_opt, opt)
					keymap_opt[1] = nil
				end
				vim.keymap.set(mode, keymap, cmd, keymap_opt)
			end
		end
	end
end

--- Wrapper for tree-sitter repeatable move,
--- avoid error when the module is not loaded
---@param forward_move_fn function
---@param backward_move_fn function
function M.make_repeatable_move_pair(forward_move_fn, backward_move_fn)
	local function move_fn(opts)
		if opts.forward then
			return forward_move_fn()
		else
			return backward_move_fn()
		end
	end

	local loaded_ts, ts_repeatable
	return function()
		if not loaded_ts then
			loaded_ts, ts_repeatable = pcall(require, "nvim-treesitter-textobjects.repeatable_move")
			if loaded_ts then
				move_fn = ts_repeatable.make_repeatable_move(move_fn)
			end
		end
		return move_fn({ forward = true })
	end, function()
		if not loaded_ts then
			loaded_ts, ts_repeatable = pcall(require, "nvim-treesitter-textobjects.repeatable_move")
			if loaded_ts then
				move_fn = ts_repeatable.make_repeatable_move(move_fn)
			end
		end
		return move_fn({ forward = false })
	end
end

--- Turn the first letter of a string to uppercase
---@param str string
---@return string uppercased
function M.firstToUpper(str)
	return (str:gsub("^%l", string.upper))
end

--- 获取窗口行号的折叠信息（包含折叠文本内容）
---@param winid number 窗口ID
---@param lnum number 行号
---@return table | nil 返回折叠信息或nil（包含lines字段）
function M.fold_info(winid, lnum)
  -- 验证窗口有效性
  local ok, buf = pcall(vim.api.nvim_win_get_buf, winid)
  if not ok or not buf then
    return nil
  end

  -- 获取基础折叠信息
  local fold_start = vim.fn.foldclosed(lnum)
  local fold_end = vim.fn.foldclosedend(lnum)

  -- 如果行号不在折叠中则返回nil
  if fold_start == -1 then
    return nil
  end

  -- 获取折叠区域内的所有行文本
  local lines = vim.api.nvim_buf_get_lines(
    buf,
    fold_start - 1,  -- Lua索引从0开始
    fold_end,        -- 结束行是exclusive的
    false            -- 不包含行尾换行符
  )

  -- 构造返回结果
  return {
    start = fold_start,
    end_ = fold_end,
    level = vim.fn.foldlevel(lnum),
    lines = lines,           -- 新增：包含所有行的文本内容
    line_count = #lines,     -- 新增：行数统计
    text = vim.fn.foldtextresult(lnum)  -- 折叠显示的预览文本
  }
end

return M
