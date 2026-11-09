-- Rex key configuration, migrated from ~/.tmux.conf and ~/.config/ghostty/config.
-- tmux prefix: ctrl+a.

-- Repeat mode: tmux `bind -r` bindings repeat via this mode.
-- ctrl+a then ctrl+r enters it; enter or escape leaves it.
rex.mode("repeat", { exclusive = true })
rex.bind("ctrl+a>ctrl+r", "client.mode.enter", { name = "repeat" })
rex.bind("repeat/enter", "client.mode.exit")
rex.bind("repeat/escape", "client.mode.exit")

-- Prefix pass-through: ctrl+a ctrl+a sends ctrl+a to the program in the pane.
rex.bind("ctrl+a>ctrl+a", "pane.send_key", { key = "ctrl+a" })

-- ctrl+c and ctrl+d are intentionally UNBOUND: Rex sends unbound keys to the
-- focused terminal directly (SIGINT / EOF). Binding them to pane.send_key made
-- Rex 0.1.0 (1853) silently drop the key instead: the binding fires, the action
-- re-enters the key dispatcher with a bound key, and nothing reaches the pane.
-- Removing the bindings restores the native pass-through path.

-- Directional navigation, ported from vim-tmux-navigator + ~/.config/yabai/tmux-yabai.sh:
-- vim running in the pane gets the key; otherwise focus the Rex pane in that
-- direction; if there is no pane that way, hand off to yabai (window, then display).
local nav_key_bytes = { left = "\8", down = "\10", up = "\11", right = "\12" }
local nav_yabai_dir = { left = "west", down = "south", up = "north", right = "east" }
local nav_yabai = "/opt/homebrew/bin/yabai"

local function is_vim(name)
  if name == nil then return false end
  -- tmpnavigator regex: g?(view|n?vim?x?)(diff)? — Lua has no group quantifiers
  local base = name:gsub("diff$", "")
  return base:match("^g?n?vim?x?$") ~= nil or base:match("^g?view$") ~= nil
end

local function focused_block()
  local v = rex.session.view{}
  if v == nil then return nil end
  for _, w in ipairs(v.windows or {}) do
    if w.window_id == v.active_window_id then return w.focused_block_id end
  end
  return nil
end

rex.action{
  name = "nav_focus",
  title = "Navigate pane or window",
  args = { direction = "string" },
  run = function(ctx, args)
    local d = args.direction
    local p = rex.block.call("com.superlogical.terminal", "process", {})
    if p ~= nil and p.foreground ~= nil and is_vim(p.foreground.name) then
      rex.block.call("com.superlogical.terminal", "write", { data = nav_key_bytes[d] })
      return
    end
    local before = focused_block()
    rex.session.focus_direction{ direction = d, wrap = false }
    if before ~= nil and focused_block() ~= before then
      return
    end
    -- no pane that way; hand off to yabai: window first, then display
    local yd = nav_yabai_dir[d]
    local r = rex.exec({ nav_yabai, "-m", "window", "--focus", yd }, { timeout = 5 })
    if r ~= nil and not r.ok then
      rex.exec({ nav_yabai, "-m", "display", "--focus", yd }, { timeout = 5 })
    end
  end,
}

rex.bind("ctrl+h", "nav_focus", { direction = "left" })
rex.bind("ctrl+j", "nav_focus", { direction = "down" })
rex.bind("ctrl+k", "nav_focus", { direction = "up" })
rex.bind("ctrl+l", "nav_focus", { direction = "right" })

-- tmux bindings
rex.bind("ctrl+a>ctrl+b", "pane.send_key", { key = "ctrl+b" })
rex.bind("ctrl+a>r", "client.config.reload")
-- Resize and zoom are only available inside repeat mode (enter with
-- `ctrl+a ctrl+r`, leave with enter or escape).
rex.bind("repeat/j", "pane.resize", { amount = 5, direction = "down" })
rex.bind("repeat/k", "pane.resize", { amount = 5, direction = "up" })
rex.bind("repeat/l", "pane.resize", { amount = 5, direction = "right" })
rex.bind("repeat/h", "pane.resize", { amount = 5, direction = "left" })
rex.bind("repeat/m", "pane.zoom")
