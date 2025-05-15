
function UpdatePackages()
    require("lazy").sync { wait = true}
    -- require("mason").update_all()
end

function ReloadConfig()
    -- 清除 Lua 模块缓存
    -- for name, _ in pairs(package.loaded) do
    --     if name:match("^user") or name:match("^plugins") or name:match("^lazy") then
    --         package.loaded[name] = nil
    --     end
    -- end

    -- 重新加载 Neovim 配置
    vim.cmd("source $MYVIMRC") -- 加载 init.lua
    -- require("lazy").sync()      -- 同步插件状态
    require("lazy").reload()
    print("Configuration and plugins reloaded!")
end

vim.api.nvim_create_user_command(
    'ReloadConfig',
    ReloadConfig,
    {}
)

vim.api.nvim_create_user_command(
    'UpdatePackages',
    UpdatePackages,
    {}
)

-- load("keymaps")

-- function load(name)
 -- local pattern = name:sub(1, 1):upper()
 -- vim.print("pattern:")
    -- vim.print(pattern)
  -- always load lazyvim, then user file
  -- if M.defaults[name] or name == "options" then
  --   _load("lazyvim.config." .. name)
  --   vim.api.nvim_exec_autocmds("User", { pattern = pattern .. "Defaults", modeline = false })
  -- end
  -- _load("config." .. name)
  -- if vim.bo.filetype == "lazy" then
  --   -- HACK: LazyVim may have overwritten options of the Lazy ui, so reset this here
  --   vim.cmd([[do VimResized]])
  -- end
  -- vim.api.nvim_exec_autocmds("User", { pattern = pattern, modeline = false })
--end

-- ---@param name "autocmds" | "options" | "keymaps"
-- function M.load(name)
--   local function _load(mod)
--     if require("lazy.core.cache").find(mod)[1] then
--       LazyVim.try(function()
--         require(mod)
--       end, { msg = "Failed loading " .. mod })
--     end
--   end
--   local pattern = "LazyVim" .. name:sub(1, 1):upper() .. name:sub(2)
--   local pattern = "LazyVim" .. name:sub(1, 1):upper() .. name:sub(2)
--   -- always load lazyvim, then user file
--   if M.defaults[name] or name == "options" then
--     _load("lazyvim.config." .. name)
--     vim.api.nvim_exec_autocmds("User", { pattern = pattern .. "Defaults", modeline = false })
--   end
--   _load("config." .. name)
--   if vim.bo.filetype == "lazy" then
--     -- HACK: LazyVim may have overwritten options of the Lazy ui, so reset this here
--     vim.cmd([[do VimResized]])
--   end
--   vim.api.nvim_exec_autocmds("User", { pattern = pattern, modeline = false })
-- end



--- Partially reload AstroNvim user settings. Includes core vim options, mappings, and highlights. This is an experimental feature and may lead to instabilities until restart.
-- function M.reload()
--   local lazy, was_modifiable = require "lazy", vim.opt.modifiable:get()
--   if not was_modifiable then vim.opt.modifiable = true end
--   lazy.reload { plugins = { M.get_plugin "astrocore" } }
--   if not was_modifiable then vim.opt.modifiable = false end
--   if M.is_available "astroui" then lazy.reload { plugins = { M.get_plugin "astroui" } } end
--   vim.cmd.doautocmd "ColorScheme"
-- end

--- Get a plugin spec from lazy
-- ---@param plugin string The plugin to search for
-- ---@return LazyPlugin? available # The found plugin spec from Lazy
-- function M.get_plugin(plugin)
--   local lazy_config_avail, lazy_config = pcall(require, "lazy.core.config")
--   return lazy_config_avail and lazy_config.spec.plugins[plugin] or nil
-- end

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
