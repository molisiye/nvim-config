return {
  --single_file_support = true,
	settings = {

		d = {
      dcdClientPath = "~/.local/share/code-d/bin/dcd-client",
      dcdServerPath = "~/.local/share/code-d/bin/dcd-server",
      enableFormatting = "true",
      servedReleaseChannel= "nightly",
      extraRoots = ".",
      projectImportPaths = {".", "src/", "source/"},
		}
	}
}
