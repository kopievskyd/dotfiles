-- Add Mason bin to PATH
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin" .. ":" .. vim.env.PATH

-- Language server configurations
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
		root_markers = { ".luarc.json", "stylua.toml", ".git" },
		settings = {
			Lua = {
				diagnostics = {
					globals = { "vim" },
				},
			},
		},
	},
}

-- Ensures that all listed servers are installed via Mason
vim.schedule(function()
	require("utils").lsp_ensure_installed(servers)
end)

-- Register each server configuration
for name, config in pairs(servers) do
	vim.lsp.config[name] = config
end

-- Enable all configured LSP servers
vim.lsp.enable(vim.tbl_keys(servers))

-- Configure LSP diagnostics display
vim.diagnostic.config({
	signs = false,
	virtual_text = {
		prefix = "■",
		source = false,
	},
	update_in_insert = true,
	severity_sort = true,
})
