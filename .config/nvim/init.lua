-- Options
vim.opt.clipboard = "unnamedplus"
vim.opt.cmdheight = 0
vim.opt.completeopt = { "menuone", "noinsert", "fuzzy" }
vim.opt.fillchars = "eob: "
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.iskeyword:append("-")
vim.opt.linebreak = true
vim.opt.number = true
vim.opt.path:append("**")
vim.opt.pumheight = 10
vim.opt.rulerformat = "%P"
vim.opt.scrolloff = 10
vim.opt.shiftwidth = 4
vim.opt.shortmess:append("I")
vim.opt.sidescrolloff = 10
vim.opt.signcolumn = "no"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.title = true
vim.opt.undofile = true
vim.opt.undolevels = 100000
vim.opt.wildignore:append({ "*/.git/*" })
vim.opt.winborder = "single"
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
vim.g.netrw_banner = 0
vim.g.netrw_fastbrowse = 0
vim.g.mapleader = ","

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Setup lazy-load
vim.api.nvim_create_autocmd("UIEnter", {
	once = true,
	callback = function()
		vim.schedule(function()
			vim.api.nvim_exec_autocmds("User", { pattern = "Lazy", modeline = false })
		end)
	end,
})

-- Keymaps
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })
vim.keymap.set("n", "<leader>e", require("utils").toggle_explore, { desc = "Toggle explore" })
vim.keymap.set("n", "<leader>ff", ":Pick files<CR>", { desc = "Open files picker" })
vim.keymap.set("n", "<leader>fg", ":Pick grep_live<CR>", { desc = "Open grep_live picker" })

-- Install plugins
vim.pack.add({
	"https://github.com/webhooked/kanso.nvim",
	"https://github.com/kylechui/nvim-surround",
	"https://github.com/nvim-mini/mini.pairs",
	"https://github.com/nvim-mini/mini.pick",
})

-- Get all inactive plugins
local unused = vim.iter(vim.pack.get())
	:filter(function(x) return not x.active end)
	:map(function(x) return x.spec.name end)
	:totable()

-- Remove unused plugins
for _, name in ipairs(unused) do
	vim.pack.del({ name })
end

-- Load plugins
require("utils").lazy_load("mini.pairs")
require("utils").lazy_load("nvim-surround")
require("utils").lazy_load("mini.pick", {
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

-- Configuration colorscheme
require("kanso").setup({
	italics = false,
	transparent = true,
	overrides = function(colors)
		local theme = colors.theme
		return {
			Pmenu = { fg = theme.ui.pmenu.fg, bg = theme.ui.pmenu.bg },
			PmenuSbar = { bg = theme.ui.pmenu.bg_sbar },
		}
	end,
})

-- Set colorscheme
vim.cmd.colorscheme("kanso")

-- Load LSP configuration
require("utils").lazy_load(function()
	require("lsp")
end)
