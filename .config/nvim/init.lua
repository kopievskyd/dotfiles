-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Options
vim.opt.clipboard = "unnamedplus"
vim.opt.cmdheight = 0
vim.opt.completeopt = { "menuone", "noinsert" }
vim.opt.fillchars = "eob: "
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.iskeyword:append("-")
vim.opt.linebreak = true
vim.opt.number = true
vim.opt.path:append("**")
vim.opt.pumheight = 10
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

-- Load plugins
require("lazy").setup({
	{ "webhooked/kanso.nvim", lazy = false, priority = 1000 },
	{ "kylechui/nvim-surround", event = "VeryLazy", opts = {} },
	{ "nvim-mini/mini.pairs", event = "VeryLazy", opts = {} },
	{ "nvim-mini/mini.pick", event = "VeryLazy", opts = {} },
	change_detection = { notify = false },
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Toggles netrw file explorer
local function toggle_explore()
	if vim.bo.filetype == "netrw" then
		local bufs = vim.fn.getbufinfo({ buflisted = 1 })
		return vim.cmd(#bufs > 0 and "b#" or "bdelete")
	end
	vim.cmd("Explore")
end

-- Keymaps
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })
vim.keymap.set("n", "<leader>e", toggle_explore, { desc = "Toggle explore" })
vim.keymap.set("n", "<leader>ff", ":Pick files<CR>", { desc = "Open files picker" })
vim.keymap.set("n", "<leader>fg", ":Pick grep_live<CR>", { desc = "Open grep_live picker" })

-- Configuration file picker
require("mini.pick").setup({
	window = {
		config = function()
			local height = math.floor(0.4 * vim.o.lines)
			local width = math.floor(0.6 * vim.o.columns)
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

-- Load colorscheme
vim.cmd.colorscheme("kanso")

-- Load LSP configuration
require("lsp")
