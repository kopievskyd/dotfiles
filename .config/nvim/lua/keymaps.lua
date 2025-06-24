local utils = require("utils")
local map = utils.map

-- Better up/down
map("n", "k", [[v:count?'k':'gk']], { expr = true, desc = "Move cursor up" })
map("n", "j", [[v:count?'j':'gj']], { expr = true, desc = "Move cursor down" })

-- Clear search highlights
map("n", "<leader>h", ":nohl<CR>", { desc = "Clear search highlights" })

-- Buffers operations
map("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })
map("n", "<leader>bf", utils.format_buffer, { desc = "Format buffer" })

-- File explorer
map("n", "<leader>e", utils.toggle_netrw, { desc = "Toggle explorer" })

-- Open pickers
map("n", "<leader>ff", ":Pick files<CR>", { desc = "Open files picker" })
map("n", "<leader>fg", ":Pick grep_live<CR>", { desc = "Open grep_live picker" })
map("n", "<leader>fb", ":Pick buffers<CR>", { desc = "Open buffers picker" })
