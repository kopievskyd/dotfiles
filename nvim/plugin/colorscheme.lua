require("kanso").setup({
	italics = false,
	transparent = true,
	colors = {
		palette = {
			inkBg0 = "#181819",
			inkBg1 = "#212124",
			inkBg2 = "#262729",
			inkBg3 = "#3c3d41",
			inkBg4 = "#4e4f54",
		},
	},
	overrides = function(colors)
		local theme = colors.theme
		return {
			Pmenu = { fg = theme.ui.pmenu.fg, bg = theme.ui.pmenu.bg },
		}
	end,
})
vim.cmd.colorscheme("kanso")
