local group = vim.api.nvim_create_augroup("Plugins", { clear = false })
vim.api.nvim_create_autocmd("CursorMoved", {
	group = group,
	once = true,
	callback = function()
		vim.cmd.packadd("nvim-surround")
		require("nvim-surround").setup()
	end,
})
