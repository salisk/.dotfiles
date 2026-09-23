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

-- k9s (terminal-mode map too, so the same key hides it while k9s is focused)
vim.keymap.set({ "n", "t" }, "<leader>kk", function()
  Snacks.terminal("k9s")
end, { desc = "K9s" })

-- workmux dashboard (floating terminal; same as tmux prefix+b popup)
vim.keymap.set({ "n", "t" }, "<leader>mm", function()
  Snacks.terminal("workmux dashboard")
end, { desc = "Workmux dashboard" })

-- workmux: open a new worktree window from neovim.
-- Prompts for a branch name and an optional task; with a task, the new
-- worktree's kimchi (via the sidekick autocommand) starts on it immediately.
vim.keymap.set("n", "<leader>ma", function()
  Snacks.input({ prompt = "Workmux worktree — branch name: " }, function(branch)
    if not branch or branch == "" then
      return
    end
    Snacks.input({ prompt = "Task for kimchi (empty = none): " }, function(task)
      local args = { "workmux", "add", branch }
      if task and task ~= "" then
        table.insert(args, "-p")
        table.insert(args, task)
      end
      vim.fn.jobstart(args, {
        detach = true,
        on_exit = function(_, code)
          if code ~= 0 then
            vim.notify("workmux add failed (exit " .. code .. ")", vim.log.levels.WARN)
          end
        end,
      })
    end)
  end)
end, { desc = "Workmux: new worktree" })

-- macOS Finder: reveal the current file (selected) in Finder;
-- falls back to the project root when no file is open
vim.keymap.set("n", "<leader>of", function()
  local file = vim.fn.expand("%:p")
  if file == "" then
    vim.ui.open(vim.fn.getcwd())
    return
  end
  vim.fn.jobstart({ "open", "-R", file }, { detach = true })
end, { desc = "Finder: reveal current file" })

-- macOS Finder: open the project root
vim.keymap.set("n", "<leader>oF", function()
  vim.ui.open(vim.fn.getcwd())
end, { desc = "Finder: project root" })

-- GitLab: open the MR for the current branch in the browser (wmw equivalent)
vim.keymap.set("n", "<leader>ow", function()
  vim.fn.jobstart({ "glab", "mr", "view", "--web" }, {
    detach = true,
    on_exit = function(_, code)
      if code ~= 0 then
        vim.notify("No open MR for the current branch", vim.log.levels.WARN)
      end
    end,
  })
end, { desc = "Open MR in browser" })

-- GitLab: view the MR for the current branch in a floating window
vim.keymap.set("n", "<leader>oM", function()
  vim.system({ "glab", "mr", "view" }, { text = true }, function(res)
    vim.schedule(function()
      if res.code ~= 0 or not res.stdout or res.stdout == "" then
        vim.notify("No open MR for the current branch", vim.log.levels.WARN)
        return
      end
      local buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(res.stdout, "\n"))
      vim.bo[buf].filetype = "markdown"
      vim.bo[buf].modifiable = false
      local width = math.floor(vim.o.columns * 0.85)
      local height = math.floor(vim.o.lines * 0.8)
      local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        border = "rounded",
        title = " Merge Request ",
        title_pos = "center",
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        width = width,
        height = height,
        style = "minimal",
      })
      vim.keymap.set("n", "q", function()
        vim.api.nvim_win_close(win, true)
      end, { buffer = buf, desc = "Close MR view" })
    end)
  end)
end, { desc = "View MR for current branch" })

-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])

-- dadbod UI
-- vim.keymap.set("n", "<leader>cq", ":DBUIToggle<CR>")

-- Check if the operating system is macOS (Darwin)
if vim.loop.os_uname().sysname == "Darwin" then
  function TmuxYabaiOrSplitSwitch(wincmd, direction)
    local previous_winnr = vim.fn.winnr()
    local at_edge

    if vim.api.nvim_win_get_config(0).relative ~= "" then
      -- Floating windows (e.g. snacks explorer) live outside the split grid:
      -- `wincmd` from a float jumps off it to the underlying window instead
      -- of following screen geometry, so the edge detection never fires.
      -- Treat a float that touches the screen edge in the navigation
      -- direction as being at that edge; otherwise fall through to wincmd
      -- (e.g. C-l from the explorer still goes to the main window).
      local pos = vim.api.nvim_win_get_position(0)
      local width = vim.api.nvim_win_get_width(0)
      local height = vim.api.nvim_win_get_height(0)
      at_edge = ({
        west = pos[2] <= 1,
        east = pos[2] + width >= vim.o.columns - 2,
        north = pos[1] <= 1,
        south = pos[1] + height >= vim.o.lines - 4,
      })[direction]
      if not at_edge then
        vim.cmd("silent! wincmd " .. wincmd)
      end
    else
      vim.cmd("silent! wincmd " .. wincmd)
    end

    local current_winnr = vim.fn.winnr()
    if at_edge or previous_winnr == current_winnr then
      vim.fn.system("~/.config/yabai/tmux-yabai.sh " .. direction)
    end

    -- When invoked from a terminal-mode map (e.g. the sidekick CLI window)
    -- and navigation stayed in this terminal window, return to terminal
    -- mode so typing keeps going to the CLI.
    if vim.bo.buftype == "terminal" then
      vim.cmd("startinsert")
    end
  end

  vim.keymap.set("n", "<C-h>", [[:lua TmuxYabaiOrSplitSwitch('h', 'west')<CR>]], { silent = true })
  vim.keymap.set("n", "<C-j>", [[:lua TmuxYabaiOrSplitSwitch('j', 'south')<CR>]], { silent = true })
  vim.keymap.set("n", "<C-k>", [[:lua TmuxYabaiOrSplitSwitch('k', 'north')<CR>]], { silent = true })
  vim.keymap.set("n", "<C-l>", [[:lua TmuxYabaiOrSplitSwitch('l', 'east')<CR>]], { silent = true })

  -- Terminal-mode variants (e.g. sidekick CLI window): leave terminal mode,
  -- then navigate the same way
  vim.keymap.set("t", "<C-h>", [[<C-\><C-n>:lua TmuxYabaiOrSplitSwitch('h', 'west')<CR>]], { silent = true })
  vim.keymap.set("t", "<C-j>", [[<C-\><C-n>:lua TmuxYabaiOrSplitSwitch('j', 'south')<CR>]], { silent = true })
  vim.keymap.set("t", "<C-k>", [[<C-\><C-n>:lua TmuxYabaiOrSplitSwitch('k', 'north')<CR>]], { silent = true })
  vim.keymap.set("t", "<C-l>", [[<C-\><C-n>:lua TmuxYabaiOrSplitSwitch('l', 'east')<CR>]], { silent = true })
end
