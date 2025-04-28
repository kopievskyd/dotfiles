local utils = require("utils")

-- Better up/down
utils.map("n", "k", [[v:count?'k':'gk']], { expr = true, desc = "Move cursor up" })
utils.map("n", "j", [[v:count?'j':'gj']], { expr = true, desc = "Move cursor down" })

-- Clear search highlights
utils.map("n", "<leader>h", ":nohl<CR>", { desc = "Clear search highlights" })

-- Buffers operations
utils.map("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
utils.map("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })
utils.map("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })
utils.map("n", "<leader>bf", utils.format_buffer, { desc = "Format buffer" })

-- File explorer
utils.map("n", "<leader>e", utils.toggle_netrw, { desc = "Toggle explorer" })

-- Open pickers
utils.map("n", "<leader>ff", ":Pick files<CR>", { desc = "Open files picker" })
utils.map("n", "<leader>fg", ":Pick grep_live<CR>", { desc = "Open grep_live picker" })
utils.map("n", "<leader>fb", ":Pick buffers<CR>", { desc = "Open buffers picker" })
