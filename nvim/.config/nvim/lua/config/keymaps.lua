-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- reload/edit configuration
vim.keymap.set("n", "<leader>ve", ":edit ~/.config/nvim/init.lua<cr>")
vim.keymap.set("n", "<leader>vr", ":source ~/.config/nvim/init.lua<cr>")

-- clear search highlights
vim.keymap.set("n", "<leader>nh", ":nohl<CR>")

-- copy to + register
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- delete selection without overwriting the register
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- delete single character without copying into register
vim.keymap.set("n", "x", '"_x')

-- window management
vim.keymap.set("n", "<leader>wv", "<C-w>v") -- split window vertically
vim.keymap.set("n", "<leader>wh", "<C-w>s") -- split window horizontally
vim.keymap.set("n", "<leader>we", "<C-w>=") -- make split windows equal width & height
vim.keymap.set("n", "<leader>wq", ":close<CR>") -- close current split window

-- restart lsp server
vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>") -- mapping to restart lsp if necessary
