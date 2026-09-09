return {
  {
    "folke/sidekick.nvim",
    opts = {
      cli = {
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
    -- The prompt is passed as `text` (not `msg`) to bypass sidekick's context
    -- variable expansion: a literal `{foo}` in the prompt would otherwise fail
    -- rendering and be discarded.
    --
    -- Workmux worktrees are detected via the default `__worktrees` directory
    -- naming; if `worktree_dir` is ever changed in the workmux config, update
    -- the detection below to match.
    init = function()
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
          if prompt and #prompt > 0 then
            -- sidekick.Text[]: list of lines, each line a list of { [1] = text } chunks
            local text = vim.tbl_map(function(line)
              return { { line } }
            end, prompt)
            require("sidekick.cli").send({
              name = "kimchi",
              text = text,
              submit = true,
            })
            return
          end
          -- No prompt to deliver: still open the sidekick window with a kimchi
          -- session, but only inside a workmux worktree.
          if vim.fn.getcwd():find("__worktrees", 1, true) then
            require("sidekick.cli").show({ name = "kimchi" })
          end
        end,
      })
    end,
  },
}
