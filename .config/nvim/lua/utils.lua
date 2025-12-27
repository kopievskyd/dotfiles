local M = {}

-- Toggle netrw file explorer
function M.toggle_explore()
	if vim.api.nvim_buf_get_option(0, "filetype") == "netrw" then
		local bufs = vim.fn.getbufinfo({ buflisted = 1 })
		return vim.cmd(#bufs > 0 and "buffer" or "bdelete")
	end
	vim.cmd("Explore")
end

-- Lazy-load
function M.lazy_load(pkg, config)
	vim.api.nvim_create_autocmd("User", {
		once = true,
		pattern = "Lazy",
		callback = type(pkg) == "function" and pkg or function()
			require(pkg).setup(config or {})
		end,
	})
end

return M
