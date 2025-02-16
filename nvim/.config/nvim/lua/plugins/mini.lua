local plugins = {
	{ "echasnovski/mini.surround", event = "VeryLazy" },
	{ "echasnovski/mini.pairs", event = "InsertEnter" },
	{ "echasnovski/mini.pick", event = "VeryLazy" },
}

return vim.tbl_map(function(plugin)
	plugin.version = plugin.version or false
	plugin.config = plugin.config or true
	return plugin
end, plugins)
