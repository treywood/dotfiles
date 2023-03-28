local wezterm = require('wezterm')
local act = wezterm.action

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.font = wezterm.font {
  family = 'Fira Code Retina',
  weight = 450,
  harfbuzz_features = { 'zero', 'ss03', 'ss09', 'cv14', 'cv16' },
  freetype_load_target = 'Light',
  freetype_render_target = 'HorizontalLcd',
}
config.font_size = 14.0
config.line_height = 1.1

config.colors = {
  foreground = '#d3c6aa',
  background = '#2b3339',

  cursor_bg = '#d3c6aa',

  ansi = {
    '#a7b0a4',
    '#e67e80',
    '#a7c080',
    '#dbbc7f',
    '#7fbbb3',
    '#d699b6',
    '#7fbbb3',
    '#d3c6aa',
  },
  brights = {
    '#a7b0a4',
    '#e67e80',
    '#a7c080',
    '#dbbc7f',
    '#7fbbb3',
    '#d699b6',
    '#7fbbb3',
    '#d3c6aa',
  },
}

config.keys = {
  {
    key = 'k',
    mods = 'CMD',
    action = act.Multiple {
      act.ClearScrollback('ScrollbackAndViewport'),
      act.SendKey { key = 'L', mods = 'CTRL' },
    },
  },
}

config.hide_tab_bar_if_only_one_tab = true

return config
