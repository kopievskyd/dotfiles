---@diagnostic disable: undefined-global
---@diagnostic disable: missing-fields

-- Options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.laststatus = 3
vim.opt.clipboard:append("unnamedplus")
vim.opt.swapfile = false
vim.opt.laststatus = 3
vim.g.netrw_banner = 0
vim.opt.shortmess:append("I")

-- Autocommands
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
})

local function toggle_netrw()
	local netrw_open = false

	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.bo[buf].filetype == "netrw" then
			netrw_open = true
			break
		end
	end

	if netrw_open then
		local buffers = vim.fn.getbufinfo({ buflisted = 1 })
		if #buffers > 0 then
			vim.cmd("buffer")
		else
			vim.cmd("bdelete")
		end
	else
		vim.cmd("Explore")
	end
end

-- Keymaps
vim.g.mapleader = " "
vim.keymap.set("n", "j", [[v:count?'j':'gj']], { noremap = true, expr = true })
vim.keymap.set("n", "k", [[v:count?'k':'gk']], { noremap = true, expr = true })
vim.keymap.set("n", "<leader>h", ":nohl<CR>", { desc = "Clear search highlights" })
vim.keymap.set("n", "<leader>e", toggle_netrw, { desc = "Toggle explorer" })
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })
vim.keymap.set("n", "<leader>bf", function()
	require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format buffer" })

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- Colorscheme
		{
			"zenbones-theme/zenbones.nvim",
			dependencies = "rktjmp/lush.nvim",
			lazy = false,
			priority = 1000,
			config = function()
				vim.g.zenwritten = {
					transparent_background = true,
				}
				vim.cmd.colorscheme("zenwritten")
			end,
		},

		-- Statusline
		{
			"nvim-lualine/lualine.nvim",
			config = function()
				require("lualine").setup({
					options = {
						component_separators = {},
						section_separators = {},
						globalstatus = true,
					},
					sections = {
						lualine_a = {},
						lualine_b = {},
						lualine_c = { "filename", { "branch", icons_enabled = false }, "diff", "diagnostics" },
						lualine_x = { "location", "progress" },
						lualine_y = {},
						lualine_z = {},
					},
				})
			end,
		},

		-- Mason
		{
			"williamboman/mason.nvim",
			dependencies = {
				"williamboman/mason-lspconfig.nvim",
				"WhoIsSethDaniel/mason-tool-installer.nvim",
			},
			config = function()
				require("mason").setup({})
				require("mason-lspconfig").setup({
					ensure_installed = {
						"lua_ls",
						"emmet_ls",
						"gopls",
					},
				})
				require("mason-tool-installer").setup({
					ensure_installed = {
						"stylua",
						"taplo",
						"beautysh",
					},
				})
			end,
		},

		-- LSP config
		{
			"neovim/nvim-lspconfig",
			event = { "BufReadPre", "BufNewFile" },
			dependencies = {
				"folke/lazydev.nvim",
				ft = "lua",
				opts = {
					library = {
						{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
					},
				},
			},
			config = function()
				local lspconfig = require("lspconfig")
				local capabilities = require("blink.cmp").get_lsp_capabilities()
				lspconfig.lua_ls.setup({
					capabilities = capabilities,
				})
				lspconfig.emmet_ls.setup({
					capabilities = capabilities,
					filetypes = {
						"html",
						"typescript",
						"javascript",
						"css",
						"sass",
						"scss",
						"less",
					},
				})
				lspconfig.gopls.setup({
					capabilities = capabilities,
					settings = {
						gopls = {
							experimentalPostfixCompletions = true,
							analyses = {
								unusedparams = true,
								shadow = true,
							},
							staticcheck = true,
						},
					},
					init_options = {
						usePlaceholders = true,
					},
				})
			end,
		},

		-- Completions
		{
			"saghen/blink.cmp",
			dependencies = "rafamadriz/friendly-snippets",
			version = "*",
			opts = {
				keymap = {
					preset = "enter",
					["<C-k>"] = { "select_prev", "fallback" },
					["<C-j>"] = { "select_next", "fallback" },
				},
				completion = {
					documentation = {
						auto_show = true,
						auto_show_delay_ms = 300,
					},
					menu = {
						draw = {
							columns = {
								{ "label", "label_description", gap = 1 },
								{ "kind_icon", "kind", gap = 1 },
							},
						},
					},
				},
				sources = {
					default = { "lsp", "path", "snippets", "buffer" },
					cmdline = {},
				},
				signature = { enabled = true },
			},
		},

		-- Formatters
		{
			"stevearc/conform.nvim",
			opts = {},
			config = function()
				require("conform").setup({
					formatters_by_ft = {
						lua = { "stylua" },
						go = { "gopls" },
						toml = { "taplo" },
						zsh = { "beautysh" },
					},
					format_on_save = {
						timeout_ms = 500,
						lsp_format = "fallback",
					},
				})
			end,
		},

		-- Treesitter
		{
			"nvim-treesitter/nvim-treesitter",
			event = { "BufReadPre", "BufNewFile" },
			build = ":TSUpdate",
			dependencies = { "windwp/nvim-ts-autotag" },
			config = function()
				require("nvim-treesitter.configs").setup({
					ensure_installed = {},
					auto_install = true,
					highlight = { enable = true },
					indent = { enable = true },
					autotag = { enable = true },
				})
			end,
		},

		-- Autopairs
		{
			"windwp/nvim-autopairs",
			event = "InsertEnter",
			config = true,
		},
	},

	change_detection = { notify = false },
})
