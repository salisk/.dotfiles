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

-- code companion
vim.keymap.set({ "n", "v" }, "<leader>za", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<leader>zc", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
vim.keymap.set("v", "<leader>zd", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

-- k9s
vim.keymap.set("n", "<leader>kk", function()
  Snacks.terminal("k9s")
end, { desc = "K9s" })

-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])

-- dadbod UI
-- vim.keymap.set("n", "<leader>cq", ":DBUIToggle<CR>")

-- Check if the operating system is macOS (Darwin)
if vim.loop.os_uname().sysname == "Darwin" then
  function TmuxYabaiOrSplitSwitch(wincmd, direction)
    local previous_winnr = vim.fn.winnr()
    vim.cmd("silent! wincmd " .. wincmd)
    local current_winnr = vim.fn.winnr()

    if previous_winnr == current_winnr then
      vim.fn.system("~/.config/yabai/tmux-yabai.sh " .. direction)
    end
  end

  vim.keymap.set("n", "<C-h>", [[:lua TmuxYabaiOrSplitSwitch('h', 'west')<CR>]], { silent = true })
  vim.keymap.set("n", "<C-j>", [[:lua TmuxYabaiOrSplitSwitch('j', 'south')<CR>]], { silent = true })
  vim.keymap.set("n", "<C-k>", [[:lua TmuxYabaiOrSplitSwitch('k', 'north')<CR>]], { silent = true })
  vim.keymap.set("n", "<C-l>", [[:lua TmuxYabaiOrSplitSwitch('l', 'east')<CR>]], { silent = true })
end
