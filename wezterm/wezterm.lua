local wezterm = require('wezterm')
local act = wezterm.action

return {
  font = wezterm.font {
    family = 'Fira Code',
    weight = 450,
    harfbuzz_features = { 'zero', 'ss03', 'ss09', 'cv14', 'cv16' },
    freetype_load_target = 'Light',
    freetype_render_target = 'HorizontalLcd',
  },
  font_size = 14.0,
  line_height = 1.1,

  colors = {
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
  },

  keys = {
    {
      key = 'k',
      mods = 'CMD',
      action = act.Multiple {
        act.ClearScrollback('ScrollbackAndViewport'),
        act.SendKey { key = 'L', mods = 'CTRL' },
      },
    },
  },

  hide_tab_bar_if_only_one_tab = true,
}
