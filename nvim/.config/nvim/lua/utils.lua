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

---Executes a git command asynchronously
---@param args string[]
---@param cwd string
---@param callback fun(output: string|nil)
local function git_async(args, cwd, callback)
	local stdout = vim.loop.new_pipe(false)
	local output = ""
	local handle

	handle = vim.loop.spawn("git", {
		args = args,
		cwd = cwd,
		stdio = { nil, stdout, nil },
	}, function(code)
		stdout:close()
		handle:close()
		callback(code == 0 and output or nil)
	end)

	stdout:read_start(function(_, data)
		if data then
			output = output .. data
		end
	end)
end

---Fetches git information for a buffer
---@param buf number
---@param filepath string
---@param cwd string
local function fetch_git_info(buf, filepath, cwd)
	git_async({ "branch", "--show-current" }, cwd, function(branch_output)
		if not branch_output or branch_output == "" then
			return
		end

		local branch = branch_output:gsub("%s+", "")

		git_async({ "status", "--porcelain", "--untracked-files=all", "--", filepath }, cwd, function(status_output)
			local dirty = (status_output and status_output ~= "") and "*" or ""
			local git_info = " %#LineNr#" .. branch .. dirty .. "%*"

			vim.schedule(function()
				if vim.api.nvim_buf_is_valid(buf) then
					pcall(vim.api.nvim_buf_set_var, buf, "git_info", git_info)
					vim.cmd.redrawstatus()
				end
			end)
		end)
	end)
end

---Get current buffer information
---@return {buf: number, bufname: string, filepath: string, filetype: string, cwd: string}
local function get_buffer_info()
	local buf = vim.api.nvim_get_current_buf()
	local bufname = vim.api.nvim_buf_get_name(buf)
	local filetype = vim.bo[buf].filetype
	local filepath = bufname ~= "" and vim.fn.fnamemodify(bufname, ":p") or ""
	local cwd = vim.loop.cwd()

	return {
		buf = buf,
		bufname = bufname,
		filepath = filepath,
		filetype = filetype,
		cwd = cwd,
	}
end

---Updates the git information for the current buffer
---Called when a file is saved to refresh git status indicators
---Fetches branch and dirty status information to keep the winbar accurate
function M.update_git_info()
	local info = get_buffer_info()

	if info.bufname == "" then
		return
	end

	fetch_git_info(info.buf, info.filepath, info.cwd)
end

---Builds the winbar content string
---@return string
function M.build_winbar()
	local info = get_buffer_info()

	-- Set icon based on buffer type and state
	local icon = (vim.bo.modified and " ")
		or ((info.filetype == "netrw" and "  ") or (info.bufname == "" and " ") or " ")

	-- Try to get cached git info
	local git_info = ""
	pcall(function()
		git_info = vim.api.nvim_buf_get_var(info.buf, "git_info")
	end)

	-- If no git info and not already updating, fetch it
	if git_info == "" and info.bufname ~= "" then
		vim.schedule(function()
			fetch_git_info(info.buf, info.filepath, info.cwd)
		end)
	end

	return icon .. "%t" .. (git_info or "")
end

return M
