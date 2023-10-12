local status, neodev = pcall(require, "neodev")
if not status then
  vim.notify("not found neodev")
  return
end

neodev.setup({})

return {
  settings = {
    Lua = {
      hint = {
        enable = true,
        arrayIndex = "Enable",
        setType = true
      }
    }
  }
}
