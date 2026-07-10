---@diagnostic disable: undefined-global

-- {{{ Globals

local g = vim.g

-- Leader key
g.mapleader = ","

-- Disable unused language providers
g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0
g.loaded_node_provider = 0

-- Netrw
g.netrw_banner = 0
g.netrw_fastbrowse = 0

-- }}}

-- {{{ Options

local opt = vim.opt

-- Show line numbers
opt.number = true

-- Don't show sign column
opt.signcolumn = "no"

-- Indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.shiftround = true
opt.smartindent = true

-- Search
opt.hlsearch = false
opt.ignorecase = true
opt.smartcase = true
opt.path:append("**")

-- Split behavior
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "screen"

-- Scroll margins
opt.scrolloff = 10
opt.sidescrolloff = 10

-- Smart line wrapping
opt.linebreak = true

-- Formatting
opt.formatoptions = "jcroqlnt"

-- Treat '-' as part of a word
opt.iskeyword:append("-")

-- Marker-based folding
opt.foldmethod = "marker"

-- Completion
opt.completeopt = "menu,menuone,noinsert,fuzzy"
opt.wildmode = "longest:full,full"
opt.pumheight = 10
opt.wildignore:append({ "*/.git/*" })

-- Appearance
opt.termguicolors = true
opt.winborder = "single"
opt.fillchars = "eob: "
opt.shortmess:append("WIcC")

-- Tabline
opt.showtabline = 2

-- Statusline
opt.laststatus = 3
opt.rulerformat = "%P"

-- Command-line
opt.cmdheight = 0

-- Undo history
opt.undofile = true
opt.undolevels = 100000

-- Don't create swap files
opt.swapfile = false

-- Confirm before closing modified buffers
opt.confirm = true

-- Set terminal title
opt.title = true

-- Sync with system clipboard
opt.clipboard = "unnamedplus"

-- }}}

-- {{{ Keymaps

local function map(mode, lhs, rhs, desc)
	vim.keymap.set(mode, lhs, rhs, { desc = desc })
end

-- Keep search matches centered
map("n", "n", "nzzzv", "Next search result (centered)")
map("n", "N", "Nzzzv", "Previous search result (centered)")

-- Keep cursor centered during half-page scrolling
map("n", "<C-d>", "<C-d>zz", "Half page down (centered)")
map("n", "<C-u>", "<C-u>zz", "Half page up (centered)")

-- Picker shortcuts
map("n", "<leader>ff", ":Pick files<CR>", "Open files picker")
map("n", "<leader>fg", ":Pick grep_live<CR>", "Open grep_live picker")

local function toggle_netrw()
	if vim.bo.filetype ~= "netrw" then
		vim.cmd.Explore()
	elseif vim.fn.exists("w:netrw_rexlocal") == 1 then
		vim.cmd.Rexplore()
	else
		vim.cmd.b("#")
	end
end

map("n", "<leader>e", toggle_netrw, "Toggle file explorer")

-- }}}

-- {{{ Autocmds

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local user = augroup("UserConfig", { clear = true })

autocmd("TextYankPost", {
	group = user,
	callback = function()
		vim.hl.on_yank()
	end,
})

autocmd("FileType", {
	group = user,
	pattern = { "sh", "zsh" },
	callback = function()
		vim.opt_local.expandtab = true
	end,
})

local function get_cfile_path()
	local file = vim.fn.expand("<cfile>")
	local path = vim.fs.joinpath(vim.b.netrw_curdir, file)
	local relpath = vim.fn.fnamemodify(path, ":.")
	return path, relpath
end

-- Override netrw's file opening behavior
autocmd("FileType", {
	group = user,
	pattern = "netrw",
	callback = function(ev)
		vim.keymap.set("n", "<CR>", function()
			local path, relpath = get_cfile_path()

			if vim.fn.filereadable(path) == 1 then
				toggle_netrw()
				vim.cmd.edit(vim.fn.fnameescape(relpath))
				return
			end

			local browse_check = vim.keycode("<Plug>NetrwLocalBrowseCheck")
			vim.api.nvim_feedkeys(browse_check, "m", false)
		end, {
			buffer = ev.buf,
			desc = "Netrw: Open selected file",
		})
	end,
})

-- Override netrw's tab-open behavior
autocmd("FileType", {
	group = user,
	pattern = "netrw",
	callback = function(ev)
		vim.keymap.set("n", "t", function()
			local _, relpath = get_cfile_path()
			toggle_netrw()
			vim.cmd.tabedit(vim.fn.fnameescape(relpath))
		end, {
			buffer = ev.buf,
			desc = "Netrw: Open selected file in new tab",
		})
	end,
})

-- Defer lazy loading until UI is ready
autocmd("UIEnter", {
	group = user,
	once = true,
	callback = function()
		vim.schedule(function()
			vim.api.nvim_exec_autocmds("User", {
				pattern = "Lazy",
				modeline = false,
			})
		end)
	end,
})

-- }}}

-- {{{  Commands

local command = vim.api.nvim_create_user_command

command("PackStatus", function()
	print(vim.inspect(vim.pack.get()))
end, {
	desc = "Show installed plugins",
})

command("PackUpdate", function()
	vim.pack.update()
end, {
	desc = "Update plugins",
})

command("PackClean", function()
	vim.iter(vim.pack.get())
		:filter(function(plugin)
			return not plugin.active
		end)
		:each(function(plugin)
			vim.pack.del({ plugin.spec.name })
		end)
end, {
	desc = "Remove inactive plugins",
})

-- }}}

-- {{{ Plugins

-- Load built-in plugins
vim.cmd.packadd("nvim.undotree")
vim.cmd.packadd("nvim.difftool")

-- Install third-party plugins
vim.pack.add({
	"https://github.com/webhooked/kanso.nvim",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/kylechui/nvim-surround",
	"https://github.com/nvim-mini/mini.pairs",
	"https://github.com/nvim-mini/mini.pick",
})

-- Lazy setup helper
local function lazy_load(pkg, config)
	vim.api.nvim_create_autocmd("User", {
		group = user,
		once = true,
		pattern = "Lazy",
		callback = function()
			require(pkg).setup(config or {})
		end,
	})
end

-- Deferred plugin setup
lazy_load("nvim-surround")
lazy_load("mini.pairs")
lazy_load("mini.pick", {
	window = {
		config = function()
			local height = math.floor(0.5 * vim.o.lines)
			local width = math.floor(0.7 * vim.o.columns)
			return {
				anchor = "NW",
				height = height,
				width = width,
				row = math.floor(0.4 * (vim.o.lines - height)),
				col = math.floor(0.5 * (vim.o.columns - width)),
			}
		end,
	},
})

-- }}}

-- {{{ Colorscheme

require("kanso").setup({
	transparent = true,
	minimal = true,
	overrides = function(colors)
		local theme = colors.theme
		return {
			Pmenu = { fg = theme.ui.pmenu.fg, bg = theme.ui.pmenu.bg },
			PmenuSbar = { bg = theme.ui.pmenu.bg_sbar },
			Operator = { fg = theme.syn.operator },
			["@keyword.operator"] = { fg = theme.syn.operator },
		}
	end,
})

-- Apply colorscheme
vim.cmd.colorscheme("kanso")

-- }}}

-- {{{ Diagnostic

vim.diagnostic.config({
	severity_sort = true,
	update_in_insert = true,
	virtual_text = {
		prefix = "●",
	},
})

-- }}}

-- {{{ Lsp

-- Initialize LSP after startup
autocmd("User", {
	group = user,
	once = true,
	pattern = "Lazy",
	callback = function()
		-- Generate completion trigger characters
		local chars = {}
		for i = 32, 126 do
			local c = string.char(i)
			if c:match("[%w_.:@$]") then
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
				})
			end,
		})

		vim.lsp.enable({ "lua_ls", "gopls", "jdtls" })
	end,
})

-- }}}
