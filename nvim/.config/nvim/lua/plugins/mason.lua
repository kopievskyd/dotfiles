return {
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
}
