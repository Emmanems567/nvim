local keymap = vim.keymap

keymap.set("i", "jk", "<ESC>", { desc = "Quit insert mode" })
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search" })
keymap.set("n", "<C-s>", ":w<CR>", { desc = "Save file" })
