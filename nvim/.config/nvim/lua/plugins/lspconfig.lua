return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		servers = {
			lua_ls = {
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			},
			gopls = {
				settings = {
					gopls = {
						analyses = {
							shadow = true,
						},
						staticcheck = true,
					},
				},
			},
		},
	},
	config = function(_, opts)
		local lspconfig = require("lspconfig")

		-- disable error/warning signs in signcolumn
		vim.diagnostic.config({
			signs = false,
		})

		-- setup LSP servers
		for server, config in pairs(opts.servers) do
			config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
			lspconfig[server].setup(config)
		end
	end,
}
