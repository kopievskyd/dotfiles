return {
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
}
