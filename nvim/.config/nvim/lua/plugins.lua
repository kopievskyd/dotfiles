return {
	-- Mason
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

	-- Completion
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
		},
	},

	-- Lspconfig
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			diagnostics = {
				signs = false,
				virtual_text = {
					prefix = "●",
					source = false,
				},
				update_in_insert = true,
				severity_sort = true,
			},
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

			if opts.diagnostics then
				vim.diagnostic.config(opts.diagnostics)
			end

			for server, config in pairs(opts.servers) do
				config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
				lspconfig[server].setup(config)
			end
		end,
	},

	-- Formatting
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

	-- Surround
	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		config = true,
	},

	-- Autopairs
	{
		"echasnovski/mini.pairs",
		event = "InsertEnter",
		version = false,
		config = true,
	},

	-- Picker
	{
		"echasnovski/mini.pick",
		event = "VeryLazy",
		version = false,
		config = true,
	},
}
