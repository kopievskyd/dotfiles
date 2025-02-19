return {
	-- colorscheme
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			transparent = true,
			colors = {
				palette = {
					sumiInk0 = "#15171b",
					sumiInk1 = "#191b1f",
					sumiInk2 = "#1d1f24",
					sumiInk3 = "#24262d",
					sumiInk4 = "#2b2e36",
					sumiInk5 = "#32363f",
					sumiInk6 = "#505563",

					oldWhite = "#a2a7b4",
					fujiWhite = "#a2a7b4",
					fujiGray = "#5e6475",
				},
				theme = {
					all = {
						ui = {
							bg_gutter = "none",
						},
					},
				},
			},
		},
		config = function(_, opts)
			opts.overrides = function(colors)
				local theme = colors.theme
				local makeDiagnosticColor = function(color)
					local c = require("kanagawa.lib.color")
					return { fg = color, bg = c(color):blend(theme.ui.bg, 0.95):to_hex() }
				end
				return {
					Boolean = { bold = false },
					MatchParen = { fg = "NONE", bold = false },
					ModeMsg = { fg = theme.syn.keyword, bold = true },
					NormalFloat = { bg = theme.ui.bg },
					TabLineFill = { fg = theme.syn.comment, bg = "NONE", bold = true },
					Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
					PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
					PmenuSbar = { bg = theme.ui.bg_m1 },
					PmenuThumb = { bg = theme.ui.bg_p2 },
					DiagnosticVirtualTextHint = makeDiagnosticColor(theme.diag.hint),
					DiagnosticVirtualTextInfo = makeDiagnosticColor(theme.diag.info),
					DiagnosticVirtualTextWarn = makeDiagnosticColor(theme.diag.warning),
					DiagnosticVirtualTextError = makeDiagnosticColor(theme.diag.error),
				}
			end
			require("kanagawa").setup(opts)
			vim.cmd.colorscheme("kanagawa")
		end,
	},

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

	-- treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre", "BufNewFile" },
		build = ":TSUpdate",
		opts = {
			ensure_installed = { "query" },
			auto_install = true,
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
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
