vim.api.nvim_create_user_command("Pick", function(opts)
	vim.cmd.packadd("mini.pick")
	require("mini.pick").setup({
		window = {
			config = function()
				local height = math.floor(0.4 * vim.o.lines)
				local width = math.floor(0.6 * vim.o.columns)
				return {
					anchor = "NW",
					height = height,
					width = width,
					row = math.floor(0.4 * (vim.o.lines - height)),
					col = math.floor(0.5 * (vim.o.columns - width)),
				}
			end,
		},
	})
	local args = opts.args or ""
	vim.cmd("Pick " .. args)
end, {
	nargs = "*",
})
