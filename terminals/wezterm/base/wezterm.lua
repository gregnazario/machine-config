-- WezTerm Configuration
-- GPU-accelerated terminal emulator

local wezterm = require('wezterm')
local config = wezterm.config.builder()

-- === Appearance ===

-- Color scheme (Dracula)
config.color_scheme = 'Dracula'

-- Window padding
config.window_padding = {
  left = 2,
  right = 2,
  top = 0,
  bottom = 0,
}

-- === Font ===

-- Font configuration
config.font = wezterm.font('JetBrains Mono', {
  weight = 'Regular',
  stretch = 'Normal',
  style = 'Normal',
})

-- Font size
config.font_size = 11.0

-- Line height
config.line_height = 1.0

-- === Window ===

-- Window decorations
config.window_decorations = "RESIZE"

-- Window background opacity
config.window_background_opacity = 0.95

-- Text background opacity
config.text_background_opacity = 1.0

-- Window close on exit
config.window_close_confirmation = 'NeverPrompt'

-- === Tab Bar ===

-- Enable tab bar
config.enable_tab_bar = true

-- Tab bar position
-- Options: "Top", "Bottom", "Left", "Right"
config.tab_bar_at_bottom = false

-- Tab bar style
config.use_fancy_tab_bar = true

-- Hide tab bar if only one tab
config.hide_tab_bar_if_only_one_tab = false

-- Tab bar format
wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local pane = tab:active_pane()
  local title = pane:title()

  -- Show pane title or default
  if title:is_empty() then
    title = wezterm.truncate_right(pane:get_foreground_process_name(), 20)
  end

  return {
    { Text = ' ' .. tab.tab_index + 1 .. ': ' .. title .. ' ' },
  }
end)

-- === Scrollbar ===

-- Hide scrollbar
config.enable_scroll_bar = false

-- === Colors ===

-- Custom colors (overrides color_scheme)
config.colors = {
  -- The default text color
  foreground = '#f8f8f2',
  -- The default background color
  background = '#282a36',

  -- Overrides the cell background color when the current cell is occupied by the
  -- cursor and the cursor style is set to Block
  cursor_bg = '#f8f8f2',
  -- Overrides the text color when the current cell is occupied by the cursor
  cursor_fg = '#282a36',
  -- The foreground color of selected text
  selection_fg = '#282a36',
  -- The background color of selected text
  selection_bg = '#f8f8f2',

  -- The color of the scrollbar "thumb"; the portion that represents the current viewport
  scrollbar_thumb = '#44475a',

  -- The color of the split lines between panes
  split = '#6272a4',

  ansi = {
    '#21222c', -- black
    '#ff5555', -- red
    '#50fa7b', -- green
    '#f1fa8c', -- yellow
    '#bd93f9', -- blue
    '#ff79c6', -- magenta
    '#8be9fd', -- cyan
    '#f8f8f2', -- white
  },
  brights = {
    '#6272a4', -- bright black
    '#ff6e6e', -- bright red
    '#69ff94', -- bright green
    '#ffffa5', -- bright yellow
    '#d6acff', -- bright blue
    '#ff92df', -- bright magenta
    '#a4ffff', -- bright cyan
    '#ffffff', -- bright white
  },
}

-- === Keys ===

-- Leader key (like tmux)
config.leader = { key = 'b', mods = 'CTRL', timeout_ms = 1000 }

-- Key bindings
config.keys = {
  -- Split horizontal
  {
    key = '-',
    mods = 'LEADER',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  -- Split vertical
  {
    key = '=',
    mods = 'LEADER',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  -- Close pane
  {
    key = 'w',
    mods = 'LEADER',
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },
  -- Move between panes
  {
    key = 'h',
    mods = 'LEADER|SHIFT',
    action = wezterm.action.ActivatePaneDirection('Left'),
  },
  {
    key = 'j',
    mods = 'LEADER|SHIFT',
    action = wezterm.action.ActivatePaneDirection('Down'),
  },
  {
    key = 'k',
    mods = 'LEADER|SHIFT',
    action = wezterm.action.ActivatePaneDirection('Up'),
  },
  {
    key = 'l',
    mods = 'LEADER|SHIFT',
    action = wezterm.action.ActivatePaneDirection('Right'),
  },
  -- Resize panes
  {
    key = 'LeftArrow',
    mods = 'ALT|SHIFT',
    action = wezterm.action.AdjustPaneSize { 'Left', 1 },
  },
  {
    key = 'RightArrow',
    mods = 'ALT|SHIFT',
    action = wezterm.action.AdjustPaneSize { 'Right', 1 },
  },
  {
    key = 'UpArrow',
    mods = 'ALT|SHIFT',
    action = wezterm.action.AdjustPaneSize { 'Up', 1 },
  },
  {
    key = 'DownArrow',
    mods = 'ALT|SHIFT',
    action = wezterm.action.AdjustPaneSize { 'Down', 1 },
  },
  -- Copy mode
  {
    key = 'Enter',
    mods = 'LEADER',
    action = wezterm.action.ActivateCopyMode,
  },
  -- New tab
  {
    key = 'c',
    mods = 'LEADER',
    action = wezterm.action.SpawnTab 'CurrentPaneDomain',
  },
  -- Close tab
  {
    key = 'q',
    mods = 'LEADER',
    action = wezterm.action.CloseCurrentTab { confirm = true },
  },
  -- Switch tabs
  {
    key = '1',
    mods = 'LEADER',
    action = wezterm.action.ActivateTab(0),
  },
  {
    key = '2',
    mods = 'LEADER',
    action = wezterm.action.ActivateTab(1),
  },
  {
    key = '3',
    mods = 'LEADER',
    action = wezterm.action.ActivateTab(2),
  },
  {
    key = '4',
    mods = 'LEADER',
    action = wezterm.action.ActivateTab(3),
  },
  {
    key = '5',
    mods = 'LEADER',
    action = wezterm.action.ActivateTab(4),
  },
  {
    key = '6',
    mods = 'LEADER',
    action = wezterm.action.ActivateTab(5),
  },
  {
    key = '7',
    mods = 'LEADER',
    action = wezterm.action.ActivateTab(6),
  },
  {
    key = '8',
    mods = 'LEADER',
    action = wezterm.action.ActivateTab(7),
  },
  {
    key = '9',
    mods = 'LEADER',
    action = wezterm.action.ActivateTab(8),
  },
  -- Scroll to bottom
  {
    key = 'k',
    mods = 'LEADER',
    action = wezterm.action.Multiple {
      wezterm.action.SendKey { key = 'End' },
    },
  },
}

-- === Mouse ===

-- Copy to clipboard on select
config.selection_word_boundary = ' {}[]()"\'/.,;=!'

-- Quick select patterns
config.quick_select_patterns = {
  -- URLs
  'https?://\\S+',
  -- File paths
  '\\S+\\.\\w+',
  -- Emails
  '\\w+@\\w+\\.\\w+',
}

-- === Shell ===

-- Default shell program
config.default_prog = { '/bin/bash' }

-- Set environment variables
config.set_environment_variables = {
  PATH = '/usr/local/bin:/usr/bin:/bin',
  TERM = 'xterm-256color',
}

-- === Launch ===

-- Initial actions
wezterm.on('gui-startup', function(cmd)
  local mux = wezterm.mux
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

return config
