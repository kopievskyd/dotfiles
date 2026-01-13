local M = {}

-- Toggle file explorer
function M.toggle_explore()
	if vim.bo.filetype ~= "netrw" then
		vim.cmd.Explore()
	elseif vim.fn.exists("w:netrw_rexlocal") == 1 then
		vim.cmd.Rexplore()
	else
		vim.cmd("b#")
	end
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
