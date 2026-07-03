return {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gosum" },
	root_markers = { "go.mod", "go.work", ".git" },
	settings = {
		gopls = {
			analyses = { shadow = true },
			staticcheck = true,
		},
	},
}
