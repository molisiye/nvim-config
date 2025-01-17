return {
  "mfussenegger/nvim-dap-python",
  ft = { "python" },
  config = function()
    require("dap-python").setup(
      vim.fs.joinpath(require("mason-registry").get_package("debugpy"):get_install_path(), "venv/bin/python")
    )
  end,
}
