local status, neodev = pcall(require, "neodev")
if not status then
	vim.notify("not found neodev")
	return
end

neodev.setup({
    runtime = true,
	override = function(_, library)
		library.enabled = true
		library.plugins = true
	end,
})

return {
	settings = {
		Lua = {
			hint = {
				enable = true,
				arrayIndex = "Enable",
				setType = true,
			},
		},
	},
}
