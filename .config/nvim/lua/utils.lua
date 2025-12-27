local M = {}

-- Toggle netrw file explorer
function M.toggle_explore()
	if vim.bo.filetype ~= "netrw" then
		return vim.cmd("Explore")
	end

	local netrw_buf = vim.api.nvim_get_current_buf()

	-- Try to switch to alternate buffer if it's valid and not netrw
	local alt_buf = vim.fn.bufnr("#")
	local switched = false

	if
		alt_buf > 0
		and vim.api.nvim_buf_is_valid(alt_buf)
		and vim.fn.buflisted(alt_buf) == 1
		and vim.fn.getbufvar(alt_buf, "&filetype") ~= "netrw"
	then
		vim.cmd("buffer " .. alt_buf)
		switched = true
	end

	-- If still in netrw, find first non-netrw buffer
	if not switched then
		for _, buf in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
			if vim.fn.getbufvar(buf.bufnr, "&filetype") ~= "netrw" then
				vim.cmd("buffer " .. buf.bufnr)
				break
			end
		end
	end

	-- Delete the netrw buffer
	if vim.api.nvim_buf_is_valid(netrw_buf) then
		vim.cmd("silent! bwipeout " .. netrw_buf)
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
