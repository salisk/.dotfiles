return {
  {
    "folke/sidekick.nvim",
    opts = {
      cli = {
        -- Disable sidekick's built-in terminal-mode window navigation
        -- (nav_left/down/up/right): at a window edge its action passes <c-hjkl>
        -- straight through to the CLI (kimchi binds them — e.g. C-l opens the
        -- model picker). The global terminal-mode maps in config/keymaps.lua
        -- (TmuxYabaiOrSplitSwitch) handle navigation instead: nvim splits ->
        -- tmux panes -> yabai windows.
        win = {
          keys = {
            nav_left = false,
            nav_down = false,
            nav_up = false,
            nav_right = false,
          },
        },
        tools = {
          kimchi = {
            cmd = { "kimchi" },
            is_proc = "\\<kimchi\\>",
            url = "https://github.com/getkimchi/kimchi",
            resume = { "--resume" },
            continue = { "--continue" },
          },
        },
      },
    },

    -- Machine-local agent choice for the worktree sidekick session.
    -- A per-machine override lives in ~/.config/nvim-local.lua (outside this
    -- repo) returning a table, e.g.: return { sidekick_tool = "codex" }
    -- Without it, the first installed tool from the preference list wins
    -- (kimchi -> codex), so machines with disjoint installs need no file at
    -- all.
    --
    -- workmux integration:
    --
    -- workmux is configured with `prompt_file_only: true`, so `workmux add` writes
    -- the prompt to .workmux/PROMPT-<branch>.md in the worktree instead of spawning
    -- an agent pane. On startup in a workmux worktree:
    --
    --   - with a prompt file: pick the newest one up, send it to kimchi
    --     (submitted, so the agent starts working right away), and consume the
    --     file so it only fires once.
    --   - without a prompt file: still open the sidekick window with a kimchi
    --     session, ready for input.
    --
    -- NOTE: we deliberately do NOT use `sidekick.cli.send`/`show` here. Both go
    -- through `State.with(attach=true)`, which routes through a session picker
    -- (`vim.ui.select`) whenever more than one kimchi state is discovered —
    -- including kimchi processes running in OTHER tmux windows. Picking one of
    -- those would hijack that session into this worktree. Instead we take the
    -- bare kimchi tool state and attach to it directly, which always creates
    -- a brand-new embedded session.
    --
    -- The prompt is passed as `text` (not `msg`) to bypass sidekick's context
    -- variable expansion: a literal `{foo}` in the prompt would otherwise fail
    -- rendering and be discarded.
    --
    -- Workmux worktrees are detected via the default `__worktrees` directory
    -- naming; if `worktree_dir` is ever changed in the workmux config, update
    -- the detection below to match. Paseo worktrees (~/.paseo/worktrees/)
    -- are deliberately NOT detected: Paseo already runs its own agent per
    -- workspace, so an auto-started sidekick session there would be a second
    -- agent in the same worktree.
    init = function()
      local function worktree_agent_tool()
        local ok, local_cfg = pcall(dofile, vim.fn.expand("~/.config/nvim-local.lua"))
        if
          ok
          and type(local_cfg) == "table"
          and type(local_cfg.sidekick_tool) == "string"
          and local_cfg.sidekick_tool ~= ""
        then
          return local_cfg.sidekick_tool
        end
        if vim.fn.executable("kimchi") == 1 then
          return "kimchi"
        end
        if vim.fn.executable("codex") == 1 then
          return "codex"
        end
        return "kimchi"
      end

      vim.api.nvim_create_autocmd("VimEnter", {
        group = vim.api.nvim_create_augroup("workmux-prompt", { clear = true }),
        callback = function()
          local prompt ---@type string[]?
          local files = vim.fn.glob(".workmux/PROMPT-*.md", false, true)
          if #files > 0 then
            -- newest first, in case the worktree was re-prompted
            table.sort(files, function(a, b)
              return vim.fn.getftime(a) > vim.fn.getftime(b)
            end)
            prompt = vim.fn.readfile(files[1])
            vim.fn.delete(files[1]) -- consume, so it only fires once
          end

          if (prompt and #prompt > 0) or vim.fn.getcwd():find("__worktrees", 1, true) then
            vim.schedule(function()
              local State = require("sidekick.cli.state")
              for _, s in ipairs(State.get({ name = worktree_agent_tool() })) do
                if not s.session and s.installed then
                  local state = State.attach(s, { show = true })
                  if state and prompt and #prompt > 0 then
                    -- sidekick.Text[]: lines of { [1] = text } chunks
                    local text = vim.tbl_map(function(line)
                      return { { line } }
                    end, prompt)
                    vim.schedule(function()
                      local msg = state.tool:format(text)
                      state.session:send(msg .. "\n")
                      state.session:submit()
                    end)
                  end
                  break
                end
              end
            end)
          end
        end,
      })
    end,
  },
}
