---@type table<string, function>
local M = {}

---Maps a keybinding
---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param opts? {expr?: boolean, desc?: string }
function M.map(mode, lhs, rhs, opts)
	opts = vim.tbl_extend("force", { noremap = true, silent = true }, opts or {})
	vim.keymap.set(mode, lhs, rhs, opts)
end

---Formats the current buffer using conform.nvim
---Runs asynchronously to avoid blocking the editor
---If LSP formatting is available but conform formatter isn't, falls back to LSP
---@see https://github.com/stevearc/conform.nvim
function M.format_buffer()
	require("conform").format({ async = true, lsp_fallback = true })
end

---Toggles the netrw file explorer
---If netrw is already open in any window, closes it
---If netrw is closed, opens it in the current window
---If there are no listed buffers when closing netrw, uses bdelete instead of buffer
function M.toggle_netrw()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "netrw" then
			return vim.cmd(#vim.fn.getbufinfo({ buflisted = 1 }) > 0 and "buffer" or "bdelete")
		end
	end
	vim.cmd("Explore")
end

---Get current buffer information
---@return {bufname: string, filetype: string, filepath: string}
local function get_buffer_info()
	local buf = vim.api.nvim_get_current_buf()
	local bufname = vim.api.nvim_buf_get_name(buf)
	local filetype = vim.bo[buf].filetype
	local filepath = ""

	if bufname ~= "" then
		local root = vim.fn.getcwd()

		if bufname:find(root, 1, true) == 1 then
			local relative = bufname:sub(#root + 1):gsub("^[/\\]", "")
			filepath = relative ~= "" and relative or vim.fn.fnamemodify(bufname, ":t")
		else
			filepath = bufname:gsub("^[/\\]", "")
		end
	end

	return {
		bufname = bufname,
		filetype = filetype,
		filepath = filepath,
	}
end

---Cached winbar content
---@type string
local winbar_context = ""

---Builds the winbar content
---@return string
function M.build_winbar()
	if vim.bo.buftype ~= "" or vim.api.nvim_win_get_config(0).relative ~= "" then
		return winbar_context
	end

	local icons = {
		explorer = "󰝰 ",
		folder = "󰉋 ",
		no_name = "󰈤 ",
		default = "󰧮 ",
		modified = "󰈙 ",
	}

	local info = get_buffer_info()
	local icon = icons.default

	if info.filetype == "netrw" then
		winbar_context = icons.explorer .. "%t"
		return winbar_context
	elseif info.bufname == "" or info.filepath == "" then
		winbar_context = icons.no_name .. "%t"
		return winbar_context
	elseif vim.bo.modified then
		icon = icons.modified
	end

	local result = {}
	local parts = vim.split(info.filepath, "/")

	for i, part in ipairs(parts) do
		local part_icon = (i == #parts) and icon or icons.folder
		table.insert(result, part_icon .. part)
	end

	winbar_context = table.concat(result, " › ")
	return winbar_context
end

return M
