return {
	"stevearc/conform.nvim",
	event = {"VeryLazy"},
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
}
