local status, neodev = pcall(require, "neodev")
if not status then
	vim.notify("not found neodev")
	return
end

neodev.setup({
	-- override = function(_, library)
	-- 	library.enabled = true
	-- 	library.plugins = true
	-- end,
})

return {
	settings = {
		Lua = {
            runtime = {
                version = "LuaJIT",
                pathStrict = true
            },
			hint = {
				enable = true,
				arrayIndex = "Enable",
				setType = true,
			},
		},
	},
}
