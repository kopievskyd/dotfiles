-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Load config
require("options")
require("autocmds")
require("keymaps")

-- Load plugins
require("lazy").setup(require("plugins"), {
	rocks = { enabled = false },
	change_detection = { notify = false },
})
