return {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".luarc.json", "stylua.toml", ".git" },
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
		},
	},
}
