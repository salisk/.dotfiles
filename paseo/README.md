# Paseo workspace config template

Canonical copy of `paseo.json` — the per-repo config Paseo reads when
creating worktree workspaces (docs: https://paseo.sh).

This is a template directory, not a stow package: it is intentionally
absent from `ansible/common/stow.yml`. The per-repo `paseo.json` cannot
be symlinked from dotfiles (it is committed inside each repo), and the
daemon config (`~/.paseo/config.json`) is deliberately NOT managed here
because it contains a bcrypt password hash and the Tailscale hostname,
and this repository is public.

## What it does

`worktree.terminals` lists commands that are automatically opened as
workspace terminals whenever a Paseo worktree workspace is created from
the repo. Each entry gets a named terminal in the app, the command is
typed into a shell rooted at the worktree, so PATH and shell syntax
resolve normally.

Combined with the nvim sidekick autocommand (see
`nvim/.config/nvim/lua/plugins/sidekick.lua`), opening a workspace gives
you neovim with an embedded kimchi session — the same flow as workmux:

    new paseo workspace → worktree → "neovim" terminal → nvim .
    → VimEnter autocmd sees ~/.paseo/worktrees/ → sidekick opens kimchi

The sidekick auto-start (embedded agent in neovim) is deliberately
workmux-only: Paseo already runs its own agent per workspace, so the
neovim terminal opens without an embedded session. The sidekick tool
choice for workmux sessions is per machine: a local override in
`~/.config/nvim-local.lua` (outside this repo) sets `sidekick_tool`,
falling back to first-installed (kimchi -> codex). The Paseo workspace
agent itself is configured per machine in the local `~/.paseo/config.json`
(agents.providers), which is deliberately not managed by these dotfiles.

## Installing into a repo

Copy this file to the repo root and commit it to the default branch —
new worktrees are cut from `origin/<default-branch>`, so the file must be
pushed there for new workspaces to inherit it:

    cp ~/code/.dotfiles/paseo/paseo.json <repo>/paseo.json
    git -C <repo> add paseo.json && git -C <repo> commit -m "Add paseo workspace config"

Notes:

- The file is read from inside each worktree (whatever the branch checks
  out), so per-branch overrides work by editing it on that branch.
- The same file also carries `worktree.setup` / `worktree.teardown`
  commands (dependency install etc.) and `worktree.servicePorts` — see
  https://paseo.sh/docs.
- Keep this template in sync when changing the repo copies.
