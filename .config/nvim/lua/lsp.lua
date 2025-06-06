local servers = {
	gopls = {
		cmd = { "gopls" },
		filetypes = { "go", "gomod", "gowork", "gotmpl", "gosum" },
		root_markers = { "go.mod", "go.work", ".git" },
		settings = {
			gopls = {
				analyses = { shadow = true },
				staticcheck = true,
			},
		},
	},
	lua_ls = {
		cmd = { "lua-language-server" },
		filetypes = { "lua" },
		root_markers = { ".luarc.json", ".luarc.jsonc", "stylua.toml", ".git" },
		settings = {
			Lua = {
				diagnostics = {
					globals = { "vim" },
				},
			},
		},
	},
}

local capabilities = require("blink.cmp").get_lsp_capabilities()

for name, config in pairs(servers) do
	config.capabilities = capabilities
	vim.lsp.config[name] = config
end

vim.diagnostic.config({
	signs = false,
	virtual_text = {
		prefix = "●",
		source = false,
	},
	update_in_insert = true,
	severity_sort = true,
})

vim.lsp.enable(vim.tbl_keys(servers))
