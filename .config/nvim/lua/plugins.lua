return {
	-- Colorscheme
	{
		"webhooked/kanso.nvim",
		opts = {
			colors = {
				palette = {
					zen0 = "#0e0e0e",
					zen1 = "#1f2022",
					zen2 = "#262729",
					zen3 = "#3c3d41",

					inkBlack0 = "#181819",
					inkBlack1 = "#212124",
					inkBlack2 = "#262729",
					inkBlack3 = "#3c3d41",
					inkBlack4 = "#4e4f54",
				},
			},
		},
		init = function()
			vim.cmd.colorscheme("kanso")
		end,
	},

	-- Mason
	{
		"mason-org/mason.nvim",
		cmd = {
			"Mason",
			"MasonUpdate",
			"MasonInstall",
			"MasonUninstall",
			"MasonUninstallAll",
		},
		lazy = true,
		opts = {},
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
		cmd = "ConformInfo",
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
			require("utils").formatters_ensure_installed(opts.formatters_by_ft)
		end,
	},

	-- Indent guides
	{
		"folke/snacks.nvim",
		opts = {
			indent = {
				animate = { enabled = false },
				scope = { enabled = false },
			},
		},
	},

	-- Surround
	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		version = "*",
		opts = {},
	},

	-- Autopairs
	{
		"echasnovski/mini.pairs",
		event = "InsertEnter",
		version = false,
		opts = {},
	},

	-- Picker
	{
		"echasnovski/mini.pick",
		cmd = "Pick",
		version = false,
		opts = {},
	},
}
