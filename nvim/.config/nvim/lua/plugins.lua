return {
	-- mason
	{
		"williamboman/mason.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		opts = {
			ensure_installed = {
				"lua-language-server",
				"gopls",
				"stylua",
				"taplo",
				"beautysh",
			},
		},
		config = function(_, opts)
			require("mason").setup()
			require("mason-tool-installer").setup(opts)
		end,
	},

	-- completion
	{
		"saghen/blink.cmp",
		event = "InsertEnter",
		version = "*",
		opts = {
			keymap = { preset = "enter" },
			completion = {
				menu = {
					draw = {
						columns = {
							{ "label", "label_description", gap = 1 },
							{ "kind_icon", "kind", gap = 1 },
						},
					},
				},
			},
			cmdline = {
				enabled = false,
			},
		},
	},

	-- lspconfig
	{
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
	},

	-- formatting
	{
		"stevearc/conform.nvim",
		event = { "VeryLazy" },
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				go = { "gopls" },
				toml = { "taplo" },
				zsh = { "beautysh" },
				sh = { "beautysh" },
			},
		},
		config = function(_, opts)
			require("conform").setup(opts)
		end,
	},

	-- surround
	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		config = true,
	},

	-- autopairs
	{
		"echasnovski/mini.pairs",
		event = "InsertEnter",
		version = false,
		config = true,
	},

	-- picker
	{
		"echasnovski/mini.pick",
		event = "VeryLazy",
		version = false,
		config = true,
	},
}
