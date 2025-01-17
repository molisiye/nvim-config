
function update_packages()
    require("lazy").sync { wait = true}
    -- require("mason").update_all()
end

vim.api.nvim_create_user_command(
    'HelloWorld',
    function() print("Hello, from init.lua!") end,
    {}
)

vim.api.nvim_create_user_command(
    'UpdatePackages',
    update_packages,
    {}
)

    -- commands = {
    --   AstroVersion = {
    --     function()
    --       local version = require("astronvim").version()
    --       if version then require("astrocore").notify(("Version: *%s*"):format(version)) end
    --     end,
    --     desc = "Check AstroNvim Version",
    --   },
    --   AstroReload = { function() require("astrocore").reload() end, desc = "Reload AstroNvim (Experimental)" },
    --   AstroUpdate = { function() require("astrocore").update_packages() end, desc = "Update Lazy and Mason" },
    -- },
-- user commands
  -- for cmd, spec in pairs(M.config.commands) do
  --   if spec then
  --     local action = spec[1]
  --     spec[1] = nil
  --     vim.api.nvim_create_user_command(cmd, action, spec)
  --     spec[1] = action
  --   end
  -- end
