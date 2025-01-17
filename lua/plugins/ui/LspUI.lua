return {
		"jinzhongjia/LspUI.nvim",
		branch = "main",
		event = "VeryLazy",
		config = function()
            require("LspUI").setup({
    inlay_hint = {
        filter = {
            -- blacklist = { "zig" },
        },
    },
})
    end
}
