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
			"rebelot/kanagawa.nvim",
			lazy = false,
			priority = 1000,
			config = function()
				require("kanagawa").setup({
					transparent = true,
					colors = {
						palette = {
							oldWhite = "#c6c9ca",
							fujiWhite = "#d4d6d8",
							dragonBlack0 = "#0f1011",
							dragonBlack1 = "#16191a",
							dragonBlack2 = "#1e2122",
							dragonBlack3 = "#222527",
							dragonBlack4 = "#2d3234",
							dragonBlack5 = "#353a3d",
							dragonBlack6 = "#40464a",
							dragonYellow = "#a99c8b",
						},
						theme = {
							dragon = {
								ui = {
									float = { bg = "#222527" },
									bg_gutter = "none",
								},
								syn = { comment = "#555a5d" },
							},
						},
					},
					overrides = function(colors)
						local palette = colors.palette
						local theme = colors.theme
						local makeDiagnosticColor = function(color)
							local c = require("kanagawa.lib.color")
							return { fg = color, bg = c(color):blend(theme.ui.bg, 0.95):to_hex() }
						end
						return {
							LineNr = { fg = palette.dragonBlack4 },
							CursorLine = { bg = palette.dragonBlack2 },
							CursorLineNr = { fg = palette.dragonBlack6 },
							MatchParen = { fg = "none", bold = false },
							ModeMsg = { fg = palette.dragonBlue2, bold = false },
							FloatBorder = { bg = theme.ui.bg_p1 },
							Boolean = { bold = false },
							Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
							PmenuSel = { fg = "none", bg = theme.ui.bg_p2 },
							PmenuSbar = { bg = theme.ui.bg_m1 },
							PmenuThumb = { bg = theme.ui.bg_p2 },
							DiagnosticVirtualTextHint = makeDiagnosticColor(theme.diag.hint),
							DiagnosticVirtualTextInfo = makeDiagnosticColor(theme.diag.info),
							DiagnosticVirtualTextWarn = makeDiagnosticColor(theme.diag.warning),
							DiagnosticVirtualTextError = makeDiagnosticColor(theme.diag.error),
						}
					end,
				})
				vim.cmd.colorscheme("kanagawa-dragon")
			end,
		},

		-- Statusline
		{
			"nvim-lualine/lualine.nvim",
			config = function()
				local colors = { bg = "#1e2122", fg = "#969c9f" }
				require("lualine").setup({
					options = {
						theme = {
							normal = {
								a = { fg = colors.fg, bg = colors.bg },
								b = { fg = colors.fg, bg = colors.bg },
								c = { fg = colors.fg, bg = colors.bg },
							},
						},
						component_separators = {},
						section_separators = {},
						globalstatus = true,
					},
					sections = {
						lualine_a = { "branch" },
						lualine_b = { "filename" },
						lualine_c = { "diagnostics" },
						lualine_x = {},
						lualine_y = { "location" },
						lualine_z = { "progress" },
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
			config = function()
				local lspconfig = require("lspconfig")
				local capabilities = require("blink.cmp").get_lsp_capabilities()
				lspconfig.lua_ls.setup({
					capabilities = capabilities,
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim" },
							},
						},
					},
				})
				lspconfig.emmet_ls.setup({
					capabilities = capabilities,
					filetypes = {
						"html",
						"typescriptreact",
						"javascriptreact",
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
