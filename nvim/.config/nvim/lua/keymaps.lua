local utils = require("utils")

-- better up/down
utils.map("n", "k", [[v:count?'k':'gk']], { expr = true, desc = "Move cursor up" })
utils.map("n", "j", [[v:count?'j':'gj']], { expr = true, desc = "Move cursor down" })

-- buffers
utils.map("n", "<leader>bb", ":bnext<CR>", { desc = "Next buffer" })
utils.map("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })

-- clear search
utils.map("n", "<leader>h", ":nohl<CR>", { desc = "Clear search highlights" })

-- toggle options
utils.map("n", "<leader>e", utils.toggle_netrw, { desc = "Toggle explorer" })

-- formatting
utils.map("n", "<leader>bf", utils.format_buffer, { desc = "Format buffer" })

-- mini.pick
utils.map("n", "<leader>ff", ":Pick files<CR>", { desc = "Open files picker" })
utils.map("n", "<leader>fg", ":Pick grep_live<CR>", { desc = "Open grep_live picker" })
utils.map("n", "<leader>fb", ":Pick buffers<CR>", { desc = "Open buffers picker" })
