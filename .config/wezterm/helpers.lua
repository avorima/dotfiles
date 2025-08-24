local wezterm = require 'wezterm'

local module = {}

wezterm.on('update-status', function(window, _)
  window:set_left_status ''
end)

wezterm.on('update-right-status', function(window, _)
  local date = wezterm.strftime(' %H:%M:%S  %a  %Y-%m-%d ');
  local hostname = ' ' .. wezterm.hostname() .. ' '

  local elements = {
      {Foreground={Color='#1b1032'}},
      {Background={Color='#0b0022'}},
      {Text=''},
      {Foreground={Color='#808080'}},
      {Background={Color='#1b1032'}},
      {Text=date},
      {Foreground={Color='#2b2042'}},
      {Background={Color='#1b1032'}},
      {Text=''},
      {Foreground={Color='#c0c0c0'}},
      {Background={Color='#2b2042'}},
      {Text=hostname},
  }

  -- local charge = 0
  -- for _, b in ipairs(wezterm.battery_info()) do
  --   charge = b.state_of_charge * 100
  --   break
  -- end

  -- local battery_fg = ''
  -- local battery_bg = ''
  -- if charge > 80 then
  --   battery_fg = '#000000'
  --   battery_bg = '#a6e3a1'
  -- elseif charge > 65 then
  --   battery_fg = '#000000'
  --   battery_bg = '#94e2d5'
  -- elseif charge > 50 then
  --   battery_fg = '#000000'
  --   battery_bg = '#f9e2af'
  -- elseif charge > 30 then
  --   battery_fg = '#000000'
  --   battery_bg = '#fab387'
  -- elseif charge > 15 then
  --   battery_fg = '#000000'
  --   battery_bg = '#eba0ac'
  -- else
  --   battery_fg = '#000000'
  --   battery_bg = '#f38ba8'
  -- end

  -- table.insert(elements, {Foreground={Color=battery_bg}})
  -- table.insert(elements, {Background={Color='#2b2042'}})
  -- table.insert(elements, {Text=''})

  -- table.insert(elements, {Foreground={Color=battery_fg}})
  -- table.insert(elements, {Background={Color=battery_bg}})

  -- local battery = string.format(' %.0f%%', charge)
  -- table.insert(elements, {Text=battery})

  window:set_right_status(wezterm.format(elements))
end)


function module.apply_to_config(config)
  config.use_fancy_tab_bar = false
  config.tab_bar_at_bottom = true

  config.show_new_tab_button_in_tab_bar = false

  config.color_scheme = 'Catppuccin Mocha'
  config.colors = {
    tab_bar = {
      background = '#0b0022',

      active_tab = {
        bg_color = '#2b2042',
        fg_color = '#c0c0c0',
        intensity = 'Bold',
      },

      inactive_tab = {
        bg_color = '#1b1032',
        fg_color = '#808080',
      },

      inactive_tab_hover = {
        bg_color = '#3b3052',
        fg_color = '#909090',
        italic = true,
      },
    },
  }
end

return module
