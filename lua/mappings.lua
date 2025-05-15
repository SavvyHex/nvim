require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- nvim-tree

map("n", "\\", "<cmd>NvimTreeFocus<CR>", { desc = "Toggle Nvim Tree" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
