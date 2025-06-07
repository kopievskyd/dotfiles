return {
	-- Mason
	{
		"mason-org/mason.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		opts = {
			ensure_installed = {
				"lua-language-server",
				"gopls",
				"stylua",
				"shfmt",
				"beautysh",
				"prettierd",
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

	-- Formatting
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				json = { "prettierd" },
				toml = { "prettierd" },
				zsh = { "beautysh" },
				sh = { "shfmt" },
			},
		},
		config = function(_, opts)
			require("conform").setup(opts)
		end,
	},

	-- Surround
	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		version = "*",
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
