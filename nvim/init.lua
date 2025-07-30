-- Options
vim.opt.clipboard = "unnamedplus"
vim.opt.completeopt = { "menuone", "noselect", "fuzzy" }
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.iskeyword:append("-")
vim.opt.linebreak = true
vim.opt.number = true
vim.opt.path:append("**")
vim.opt.pumheight = 10
vim.opt.relativenumber = true
vim.opt.scrolloff = 10
vim.opt.shiftwidth = 4
vim.opt.sidescrolloff = 10
vim.opt.signcolumn = "yes"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.undolevels = 100000
vim.opt.wildignore:append({ "*/.git/*" })

-- Disable providers
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- Netrw settings
vim.g.netrw_banner = 0
vim.g.netrw_fastbrowse = 0

-- Set leader key
vim.g.mapleader = ","

-- Keymaps
vim.keymap.set({ "n", "v" }, "j", [[v:count?'j':'gj']], { expr = true })
vim.keymap.set({ "n", "v" }, "k", [[v:count?'k':'gk']], { expr = true })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })
vim.keymap.set("n", "<leader>e", require("explore").toggle, { desc = "Toggle explore" })
vim.keymap.set("n", "<leader>ff", ":Pick files<CR>", { desc = "Open files picker" })
vim.keymap.set("n", "<leader>fg", ":Pick grep_live<CR>", { desc = "Open grep_live picker" })

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.hl.on_yank()
	end,
})
