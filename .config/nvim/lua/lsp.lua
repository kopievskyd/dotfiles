local servers = {}
local config_files = vim.api.nvim_get_runtime_file("lsp/*.lua", true)
for _, config_file in ipairs(config_files) do
	local name = config_file:match("([^/]*)%.lua$")
	if name and (name:len() > 0) then
		table.insert(servers, name)
	end
end

local chars = {}
for i = 32, 126 do
	local c = string.char(i)
	if c:match("[%w_]") or c == "." or c == ":" or c == "@" or c == "$" then
		table.insert(chars, c)
	end
end

vim.lsp.config("*", {
	on_init = function(client, _)
		client.server_capabilities.semanticTokensProvider = nil
		client.server_capabilities.completionProvider.triggerCharacters = chars
	end,
	on_attach = function(client, bufnr)
		vim.lsp.completion.enable(true, client.id, bufnr, {
			autotrigger = true,
			convert = function(item)
				return { abbr = item.label:gsub("%b()", "") }
			end,
		})
	end,
})

vim.lsp.enable(servers)

vim.diagnostic.config({
	virtual_text = true,
	severity_sort = true,
	update_in_insert = true,
})
