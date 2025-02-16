local util = require("util")

-- better up/down
util.map("n", "k", [[v:count?'k':'gk']], { expr = true, desc = "Move cursor up" })
util.map("n", "j", [[v:count?'j':'gj']], { expr = true, desc = "Move cursor down" })

-- buffers
util.map("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
util.map("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })

-- clear search
util.map("n", "<leader>h", ":nohl<CR>", { desc = "Clear search highlights" })

-- toggle options
util.map("n", "<leader>e", util.toggle_netrw, { desc = "Toggle explorer" })

-- formatting
util.map("n", "<leader>bf", util.format_buffer, { desc = "Format buffer" })

-- mini.pick
util.map("n", "<leader>ff", ":Pick files<CR>", { desc = "Open files picker" })
util.map("n", "<leader>fg", ":Pick grep_live<CR>", { desc = "Open grep_live picker" })
