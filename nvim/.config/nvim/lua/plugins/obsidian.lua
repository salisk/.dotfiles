local obsidian_relative_path = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/ObsidianNotes"

return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = false,
  ft = "markdown",
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
  --   "BufReadPre path/to/my-vault/**.md",
  --   "BufNewFile path/to/my-vault/**.md",
  -- },
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",

    -- see below for full list of optional dependencies 👇
  },
  keys = {
    {
      "<leader>on",
      function()
        vim.api.nvim_command("ObsidianNew")
        vim.api.nvim_buf_set_lines(0, 0, -1, false, {}) -- Clear buffer
        vim.api.nvim_command("ObsidianTemplate Core") -- Apply Core Template
      end,
      desc = "Create new note",
    },
    { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Search Obsidian notes" },
    { "<leader>od", "<cmd>ObsidianToday<cr>", desc = "Open daily note" },
    { "<leader>oo", "<cmd>ObsidianQuickSwitch<cr>", desc = "Quick Switch" },
    { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Show location list of backlinks" },
    { "<leader>of", "<cmd>ObsidianFollowLink<cr>", desc = "Follow link under cursor" },
    { "<leader>ot", "<cmd>ObsidianTemplate Core<cr>", desc = "Apply Core Template" },
    { "<leader>og", "<cmd>ObsidianGitSync<cr>", desc = "Sync changes to git" },
  },
  opts = {
    attachments = { img_folder = obsidian_relative_path .. "/_resources" },
    completion = { nvim_cmp = true },
    templates = { folder = obsidian_relative_path .. "/Templates", date_format = "%y%m%d", time_format = "%H%M" },
    workspaces = {
      {
        name = "personal",
        path = obsidian_relative_path,
        overrides = {
          daily_notes = {
            folder = "Daily",
          },
        },
      },
      -- {
      --   name = "work",
      --   path = "~/vaults/work",
      -- },
    },
    note_id_func = function(title)
      if title ~= nil then
        return title
      else
        return os.date("%Y%m%d%H%M%S")
      end
    end,

    -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
    -- URL it will be ignored but you can customize this behavior here.
    ---@param url string
    follow_url_func = function(url)
      -- Open the URL in the default web browser.
      vim.fn.jobstart({ "open", url }) -- Mac OS
      -- vim.fn.jobstart({"xdg-open", url})  -- linux
      -- vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
      -- vim.ui.open(url) -- need Neovim 0.10.0+
    end,

    -- Optional, by default when you use `:ObsidianFollowLink` on a link to an image
    -- file it will be ignored but you can customize this behavior here.
    ---@param img string
    follow_img_func = function(img)
      vim.fn.jobstart({ "qlmanage", "-p", img }) -- Mac OS quick look preview
      -- vim.fn.jobstart({"xdg-open", url})  -- linux
      -- vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
    end,
  },
  -- sync changes to git
  config = function(_, opts)
    require("obsidian").setup(opts)
    local job = require("plenary.job")
    local update_interval_mins = 5

    -- Function to expand the tilde (~) to the full path
    local function expand_home(path_str)
      if path_str:sub(1, 1) == "~" then
        local home = os.getenv("HOME")
        if home then
          return path_str:gsub("^~", home)
        else
          -- Handle the case where HOME is not set (should be rare)
          error("HOME environment variable is not set")
        end
      end
      return path_str
    end

    local obsidian_path = expand_home(obsidian_relative_path)

    -- check for any changes in the vault & pull them in
    local function pull_changes()
      job
        :new({
          command = "git",
          args = { "pull" },
          cwd = obsidian_path,
        })
        :start()
    end

    local function remove_lock()
      job
        :new({
          command = "rm",
          args = { ".git/index.lock" },
          cwd = obsidian_path,
        })
        :start()
    end

    local function push_changes()
      vim.notify("Pushing updates...", 2, { title = "Obsidian.nvim" })
      job
        :new({
          command = "git",
          args = { "push" },
          cwd = obsidian_path,
        })
        :start()
    end

    local function commit_changes()
      local timestamp = os.date("%Y-%m-%d %H:%M:%S")
      job
        :new({
          command = "git",
          args = { "commit", "-m", "vault backup: " .. timestamp },
          cwd = obsidian_path,
          on_exit = function()
            push_changes()
          end,
          on_stderr = function(_, data)
            vim.notify("Error committing changes: " .. data, 2, { title = "Obsidian.nvim" })
          end,
        })
        :start()
    end

    local function stage_changes()
      vim.notify("Performing git sync...", 2, { title = "Obsidian.nvim" })
      job
        :new({
          command = "git",
          args = { "add", "." },
          cwd = obsidian_path,
          on_exit = function()
            commit_changes()
          end,
          on_stderr = function(_, data)
            vim.notify("Error staging changes: " .. data, 2, { title = "Obsidian.nvim" })
          end,
        })
        :start()
    end

    local function sync_changes()
      remove_lock()
      stage_changes()
      pull_changes()
    end

    local function schedule_update()
      vim.defer_fn(function()
        sync_changes()
        schedule_update()
      end, update_interval_mins * 60 * 1000)
    end

    schedule_update()

    vim.api.nvim_create_user_command("ObsidianGitSync", function()
      sync_changes()
    end, {})
  end,
}
