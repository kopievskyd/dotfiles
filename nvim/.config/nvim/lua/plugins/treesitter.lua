return {
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
}
