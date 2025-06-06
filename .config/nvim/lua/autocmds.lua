local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
autocmd("TextYankPost", {
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Disable LSP semantic tokens
autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client.server_capabilities.semanticTokensProvider then
			client.server_capabilities.semanticTokensProvider = nil
		end
	end,
})

-- Automatically delete empty buffers
autocmd("BufEnter", {
	callback = function()
		local current_buf = vim.api.nvim_get_current_buf()
		for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
			if
				bufnr ~= current_buf
				and vim.api.nvim_buf_get_name(bufnr) == ""
				and vim.api.nvim_buf_is_loaded(bufnr)
				and vim.bo[bufnr].buftype == ""
			then
				vim.api.nvim_buf_delete(bufnr, { force = true })
			end
		end
	end,
})

-- Automatically delete directory buffers
autocmd("BufEnter", {
	callback = function()
		local current_buf = vim.api.nvim_get_current_buf()
		local name = vim.api.nvim_buf_get_name(current_buf)
		if vim.fn.isdirectory(name) == 1 then
			vim.schedule(function()
				vim.api.nvim_buf_delete(current_buf, { force = true })
			end)
		end
	end,
})

-- Make background transparent
autocmd({ "OptionSet", "ColorScheme" }, {
	callback = function()
		local function apply_transparent()
			pcall(vim.api.nvim_set_hl, 0, "Normal", { bg = "NONE", ctermbg = "NONE" })
			pcall(vim.api.nvim_set_hl, 0, "NormalNC", { bg = "NONE", ctermbg = "NONE" })
			pcall(vim.api.nvim_set_hl, 0, "WinBar", { bg = "NONE", ctermbg = "NONE" })
			pcall(vim.api.nvim_set_hl, 0, "WinBarNC", { bg = "NONE", ctermbg = "NONE" })
			pcall(vim.api.nvim_set_hl, 0, "MiniPickNormal", { bg = "NONE", ctermbg = "NONE" })
			pcall(vim.api.nvim_set_hl, 0, "MiniPickBorder", { bg = "NONE", ctermbg = "NONE" })
		end
		apply_transparent()
		vim.defer_fn(apply_transparent, 100)
	end,
})
