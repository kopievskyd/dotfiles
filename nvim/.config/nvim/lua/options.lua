local g = vim.g

-- set leader key
g.mapleader = ","

-- disable netrw banner
g.netrw_banner = 0

local opt = vim.opt

opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- sync with system clipboard
opt.expandtab = true -- use spaces instead of tabs
opt.fillchars = "eob: " -- hide end-of-buffer marker
opt.hlsearch = true -- highlight search results
opt.ignorecase = true -- ignore case in search patterns
opt.incsearch = true -- show search matches as you type
opt.laststatus = 0 -- global statusline
opt.linebreak = true -- wrap lines at convenient points
opt.number = true -- print line number
opt.ruler = false -- disable the default ruler in statusline
opt.shiftround = true -- round indent to multiple of shiftwidth
opt.shiftwidth = 4 -- size of an indent
opt.shortmess:append({ I = true }) -- suppress certain messages in cmd
opt.showcmd = false -- disable command display
opt.smartcase = true -- don't ignore case with capitals
opt.smartindent = true -- insert indents automatically
opt.smoothscroll = true -- enable smooth scrolling
opt.swapfile = false -- disable swap file creation
opt.tabstop = 4 -- number of spaces tabs count for
opt.undofile = true -- enable persistent undo history
opt.undolevels = 10000 -- set maximum number of undo levels
opt.wildmode = "longest:full,full" -- command-line completion mode
opt.winbar = "%!v:lua.require'utils'.build_winbar()" -- show filename with icon in winbar
