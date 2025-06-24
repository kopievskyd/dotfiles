-- Set leader key
vim.g.mapleader = ","

-- Disable netrw banner
vim.g.netrw_banner = 0

local opt = vim.opt

-- Sync with system clipboard
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"

opt.expandtab = true -- Use spaces instead of tabs
opt.fillchars = "eob: " -- Hide end-of-buffer marker
opt.hlsearch = true -- Highlight search results
opt.ignorecase = true -- Ignore case in search patterns
opt.incsearch = true -- Show search matches as you type
opt.laststatus = 0 -- Disable statusline
opt.linebreak = true -- Wrap lines at convenient points
opt.number = true -- Print line number
opt.ruler = false -- Disable the default ruler in statusline
opt.shiftround = true -- Round indent to multiple of shiftwidth
opt.shiftwidth = 4 -- Size of an indent

-- Suppress certain messages in cmd
opt.shortmess:append({ F = true, W = true, I = true })

opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.smoothscroll = true -- Enable smooth scrolling
opt.swapfile = false -- Disable swap file creation
opt.tabstop = 4 -- Number of spaces tabs count for
opt.termguicolors = true -- True color support
opt.title = true -- Enable terminal title with file info

-- Custom terminal title
opt.titlestring = "%{%v:lua.require('utils').build_title()%}"

opt.undofile = true -- Enable persistent undo history
opt.undolevels = 10000 -- Set maximum number of undo levels
opt.wildmode = "longest:full,full" -- Command-line completion mode
