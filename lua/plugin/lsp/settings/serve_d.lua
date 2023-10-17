return {
  --single_file_support = true,
	settings = {

		d = {
      dcdClientPath = "/home/galaxy/.local/share/nvim/mason/packages/dcd-client",
      dcdServerPath = "/home/galaxy/.local/share/nvim/mason/packages/dcd-server",
      enableFormatting = "true",
      servedReleaseChannel= "nightly",
      extraRoots = ".",
      projectImportPaths = {".", "src/", "source/"},
		}
	}
}
