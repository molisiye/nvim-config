local M = {}

function M.keymap(mode, lhs, rhs, opt)
	vim.keymap.set(mode, lhs, rhs, opt)
end

function M.empty_map_table()
	local maps = {}
	for _, mode in ipairs({ "", "n", "v", "x" }) do
		maps[mode] = {}
	end
	return maps
end

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
                vim.keymap.set(mode,keymap,cmd,keymap_opt)
			end
		end
	end
end

return M
