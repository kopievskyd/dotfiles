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
	local loaded, conform = pcall(require, "conform")
	if loaded then
		conform.format({ async = true, lsp_fallback = true })
	end
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
---@return { bufname: string, filetype: string, filepath: string }
local function get_buffer_info()
	local cwd = vim.fn.getcwd()
	local buf = vim.api.nvim_get_current_buf()
	local bufname = vim.api.nvim_buf_get_name(buf)
	local filetype = vim.bo[buf].filetype
	local filepath = ""

	if bufname ~= "" then
		if bufname:find(cwd, 1, true) == 1 then
			local relative = bufname:sub(#cwd + 1):gsub("^[/\\]", "")
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

---Builds a custom terminal title
---@return string title
function M.build_title()
	local info = get_buffer_info()
	local modified = vim.bo.modified and " [+]" or ""

	if info.filetype == "netrw" then
		return "%t"
	elseif info.bufname == "" or info.filepath == "" then
		return "[No Name]"
	end

	return info.filepath .. modified .. " - nvim"
end

---Starts an LSP server
---@param name string
---@param config table<string, any>
local function lsp_start(name, config)
	local clients = vim.lsp.get_clients({ name = name })
	if #clients == 0 then
		vim.lsp.start({
			name = name,
			cmd = config.cmd,
			root_dir = vim.fs.root(0, config.root_markers),
			settings = config.settings,
		})
	end
end

---Automatically installs and starts LSP servers through Mason
---@param servers table<string, table>
function M.lsp_ensure_installed(servers)
	local loaded, registry = pcall(require, "mason-registry")
	if loaded then
		registry.refresh(function()
			for name, config in pairs(servers) do
				local ok, pkg = pcall(registry.get_package, config.cmd[1])
				if ok and not pkg:is_installed() then
					pkg:once("install:success", function()
						vim.schedule(function()
							vim.notify(name .. " installed", vim.log.levels.INFO)
							if vim.tbl_contains(config.filetypes, vim.bo.filetype) then
								lsp_start(name, config)
							end
						end)
					end)
					pkg:install()
				end
			end
		end)
	end
end

---Automatically installs formatters through Mason
---@param formatters table<string, string[]>
function M.formatters_ensure_installed(formatters)
	local loaded, registry = pcall(require, "mason-registry")
	if loaded then
		registry.refresh(function()
			for _, formatter in pairs(formatters) do
				local name = formatter[1]
				local ok, pkg = pcall(registry.get_package, name)
				if ok and not pkg:is_installed() then
					pkg:once("install:success", function()
						vim.schedule(function()
							vim.notify(name .. " installed", vim.log.levels.INFO)
						end)
					end)
					pcall(function()
						pkg:install()
					end)
				end
			end
		end)
	end
end

return M
