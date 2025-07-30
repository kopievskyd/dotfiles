local group = vim.api.nvim_create_augroup("Plugins", { clear = false })
vim.api.nvim_create_autocmd("InsertEnter", {
	group = group,
	once = true,
	callback = function()
		vim.cmd.packadd("mini.pairs")
		require("mini.pairs").setup()
	end,
})
