---@type table<string, function>
local M = {}

local keymap = vim.keymap

---maps a keybinding
---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param opts? {expr?: boolean, desc?: string }
function M.map(mode, lhs, rhs, opts)
	opts = vim.tbl_extend("force", { noremap = true, silent = true }, opts or {})
	keymap.set(mode, lhs, rhs, opts)
end

---toggles the netrw file explorer
---if netrw is already open in any window, closes it
---if netrw is closed, opens it in the current window
---if there are no listed buffers when closing netrw, uses bdelete instead of buffer
function M.toggle_netrw()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "netrw" then
			return vim.cmd(#vim.fn.getbufinfo({ buflisted = 1 }) > 0 and "buffer" or "bdelete")
		end
	end
	vim.cmd("Explore")
end

---formats the current buffer using conform.nvim
---runs asynchronously to avoid blocking the editor
---if LSP formatting is available but conform formatter isn't, falls back to LSP
---@see https://github.com/stevearc/conform.nvim
function M.format_buffer()
	require("conform").format({ async = true, lsp_fallback = true })
end

---builds the winbar string with icon, file name ang git info
---@return string
function M.build_winbar()
	local buf = vim.api.nvim_get_current_buf()
	local bufname = vim.api.nvim_buf_get_name(buf)
	local filetype = vim.bo[buf].filetype

	local icon = (vim.bo.modified and " ")
		or ((filetype == "netrw" and "  ") or (bufname == "" and " ") or " ")

	local git_branch = ""
	local handle = io.popen("git branch --show-current 2>/dev/null")
	if handle then
		git_branch = handle:read("*l") or ""
		handle:close()
	end

	local dirty = ""
	if bufname ~= "" and git_branch ~= "" then
		local cmd = string.format(
			"git status --porcelain --untracked-files=all -- %s 2>/dev/null",
			vim.fn.shellescape(vim.fn.fnamemodify(bufname, ":p"))
		)
		local stat = io.popen(cmd)
		if stat then
			dirty = stat:read("*a") ~= "" and "*" or ""
			stat:close()
		end
	end

	local git_info = (git_branch ~= "") and (" %#LineNr#" .. git_branch .. dirty .. "%*") or ""

	return icon .. "%t" .. git_info
end

return M
