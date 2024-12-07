local wezterm = require 'wezterm'
local act = wezterm.action
local helpers = require 'helpers'
local config = {}

helpers.apply_to_config(config)

-- TODO: remove when hyprland issue is resolved
config.enable_wayland = false

config.scrollback_lines = 64000

config.audible_bell = 'Disabled'

config.font =  wezterm.font_with_fallback {
  'Source Code Pro for Powerline',
  'Ubuntu Mono derivative Powerline',
}
config.font_size = 9.0
config.adjust_window_size_when_changing_font_size = true

config.leader = { key = 'b', mods = 'ALT', timeout_milliseconds = 1000 }
config.keys = {
  -- unbind
  { key = 'Space', mods = 'CTRL|SHIFT', action = act.Nop },
  { key = 'F',     mods = 'CTRL|SHIFT', action = act.Nop },
  { key = 'W',     mods = 'CTRL',       action = act.Nop },
  -- misc
  { key = 'f', mods = 'LEADER', action = act.QuickSelect },
  { key = '/', mods = 'LEADER', action = act.Search("CurrentSelectionOrEmptyString") },
  { key = 'b', mods = 'LEADER|ALT', action = act.SendKey { key = 'b', mods = 'ALT' }},
  -- panes
  { key = '|', mods = 'LEADER|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' }},
  { key = '-', mods = 'LEADER',       action = act.SplitVertical { domain = 'CurrentPaneDomain' }},
  { key = 'h', mods = 'LEADER',       action = act.ActivatePaneDirection 'Left' },
  { key = 'l', mods = 'LEADER',       action = act.ActivatePaneDirection 'Right' },
  { key = 'k', mods = 'LEADER',       action = act.ActivatePaneDirection 'Up' },
  { key = 'j', mods = 'LEADER',       action = act.ActivatePaneDirection 'Down' },
  { key = 'n', mods = 'LEADER|SHIFT', action = act.PaneSelect { mode = 'MoveToNewTab' }},
  -- tabs
  { key = 'c', mods = 'LEADER',       action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'p', mods = 'LEADER',       action = act.ActivateTabRelative(-1) },
  { key = 'n', mods = 'LEADER',       action = act.ActivateTabRelative(1) },
  { key = '<', mods = 'LEADER|SHIFT', action = act.MoveTabRelative(-1) },
  { key = '>', mods = 'LEADER|SHIFT', action = act.MoveTabRelative(1) },
  -- copy / paste
  { key = '[', mods = 'LEADER',     action = act.ActivateCopyMode },
  { key = ']', mods = 'LEADER',     action = act.PasteFrom 'PrimarySelection' },
  { key = 'v', mods = 'CTRL|SHIFT', action = act.PasteFrom 'Clipboard' },
  {
    key = 'c',
    mods = 'CTRL|SHIFT',
    action = wezterm.action_callback(function(window, pane)
      local sel = window:get_selection_text_for_pane(pane)
      if (not sel or sel == '') then
        window:perform_action(act.SendKey { key = 'c', mods = 'CTRL' }, pane)
      else
        window:perform_action(wezterm.action{ CopyTo = 'ClipboardAndPrimarySelection' }, pane)
      end
    end),
  },
}

for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'LEADER',
    action = act.ActivateTab(i - 1),
  })
end

return config
