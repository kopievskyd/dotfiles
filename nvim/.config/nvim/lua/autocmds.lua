local autocmd = vim.api.nvim_create_autocmd

-- highlight on yank
autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- disable LSP semantic tokens
autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client.server_capabilities.semanticTokensProvider then
			client.server_capabilities.semanticTokensProvider = nil
		end
	end,
})

-- automatically delete empty buffers
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

-- automatically delete directory buffers
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

-- make background transparent
autocmd("OptionSet", {
	pattern = "background" ,
	callback = function()
		local function apply_transparent()
			pcall(vim.api.nvim_set_hl, 0, "Normal", { bg = "NONE", ctermbg = "NONE" })
			pcall(vim.api.nvim_set_hl, 0, "NormalNC", { bg = "NONE", ctermbg = "NONE" })
		end
		apply_transparent()
		vim.defer_fn(apply_transparent, 10)
	end,
})

-- set diagnostic highlights
autocmd("OptionSet", {
	pattern = "background",
	callback = function()
		local theme = vim.o.background
		local palette = {
			Error = { light = { "#ff5370", "#ffd7d7" }, dark = { "#ff5370", "#3f0000" } },
			Warn = { light = { "#9a6700", "#fffacd" }, dark = { "#ffcb6b", "#3f2500" } },
			Hint = { light = { "#007300", "#e0f5e0" }, dark = { "#c3e88d", "#003f00" } },
			Info = { light = { "#0064c7", "#d7e5f0" }, dark = { "#82aaff", "#002a3f" } },
		}
		for type, variants in pairs(palette) do
			local fg = variants[theme][1]
			local bg = variants[theme][2]
			vim.api.nvim_set_hl(0, "DiagnosticVirtualText" .. type, { fg = fg, bg = bg, bold = true })
			vim.api.nvim_set_hl(0, "DiagnosticUnderline" .. type, { sp = fg, undercurl = true })
		end
	end,
})
