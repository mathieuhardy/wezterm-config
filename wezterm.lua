local wezterm = require("wezterm")
local config = wezterm.config_builder()

local book_mode = false
local current_theme = 1

--------------------------------------------------------------------------------
-- General
--------------------------------------------------------------------------------

config.automatically_reload_config = false

config.initial_cols = 120
config.initial_rows = 40
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

config.enable_tab_bar = true
config.enable_scroll_bar = true

config.font = wezterm.font("CommitMono Nerd Font Mono")
config.font_size = 10
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }

config.audible_bell = "Disabled"

config.default_cursor_style = "SteadyBlock"
config.cursor_blink_rate = 0

--------------------------------------------------------------------------------
-- Theme(s)
--------------------------------------------------------------------------------

local themes = {
  -- Greyish themes
  "Monokai Pro (Gogh)",
  "Idle Toes (Gogh)",

  -- Blueish themes
  "Nord (Gogh)",
  "Whimsy",
}

config.color_scheme = themes[current_theme]
config.colors = {}

--------------------------------------------------------------------------------
-- Tabbar
--------------------------------------------------------------------------------

local scheme = wezterm.color.get_builtin_schemes()[config.color_scheme]

config.use_fancy_tab_bar = false
config.window_frame = { font_size = 9 }

config.colors.tab_bar = {
  background = scheme.background,

  active_tab = {
    bg_color = scheme.ansi[5],
    fg_color = scheme.background,
  },

  inactive_tab = {
    bg_color = scheme.background,
    fg_color = scheme.foreground,
  },

  inactive_tab_hover = {
    bg_color = "#f8f8f8",
    fg_color = "#272727",
  },

  new_tab = {
    bg_color = scheme.background,
    fg_color = scheme.ansi[5],
  },

  new_tab_hover = {
    bg_color = "#f8f8f8",
    fg_color = "#272727",
  },
}

--------------------------------------------------------------------------------
-- Scrollbar
--------------------------------------------------------------------------------

config.colors.scrollbar_thumb = "#666666"

--------------------------------------------------------------------------------
-- Keybindings
--------------------------------------------------------------------------------

config.disable_default_key_bindings = true

config.keys = {
  -- Copy/Paste
  {
    key = "c",
    mods = "CTRL|SHIFT",
    action = wezterm.action.CopyTo("Clipboard"),
  },
  {
    key = "v",
    mods = "CTRL|SHIFT",
    action = wezterm.action.PasteFrom("Clipboard"),
  },
  -- Font size
  {
    key = "-",
    mods = "CTRL|SHIFT",
    action = wezterm.action.DecreaseFontSize,
  },
  {
    key = "=",
    mods = "CTRL|SHIFT",
    action = wezterm.action.IncreaseFontSize,
  },
  {
    key = "+",
    mods = "CTRL|SHIFT",
    action = wezterm.action.IncreaseFontSize,
  },
  {
    key = "0",
    mods = "CTRL|SHIFT",
    action = wezterm.action.ResetFontSize,
  },
  -- Tabs
  {
    key = "t",
    mods = "CTRL|SHIFT",
    action = wezterm.action.SpawnTab("CurrentPaneDomain"),
  },
  {
    key = "w",
    mods = "CTRL|SHIFT",
    action = wezterm.action.CloseCurrentTab({ confirm = true }),
  },
  {
    key = "Tab",
    mods = "CTRL",
    action = wezterm.action.ActivateTabRelative(1),
  },
  {
    key = "Tab",
    mods = "CTRL|SHIFT",
    action = wezterm.action.ActivateTabRelative(-1),
  },
  -- New window
  {
    key = "n",
    mods = "CTRL|SHIFT",
    action = wezterm.action.SpawnWindow,
  },
  -- Search
  {
    key = "f",
    mods = "CTRL|SHIFT",
    action = wezterm.action.Search({ CaseInSensitiveString = "" }),
  },
  -- Configuration
  {
    key = "r",
    mods = "CTRL|SHIFT",
    action = wezterm.action.ReloadConfiguration,
  },
  -- Clear
  {
    key = "g",
    mods = "CTRL|SHIFT",
    action = wezterm.action.ResetTerminal,
  },
  -- Splits
  {
    key = "F3",
    mods = "SUPER",
    action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "F4",
    mods = "SUPER",
    action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  -- Custom
  {
    key = "b",
    mods = "CTRL|SHIFT",
    action = wezterm.action.EmitEvent("toggle_book_mode"),
  },
  {
    key = "s",
    mods = "CTRL|SHIFT",
    action = wezterm.action.EmitEvent("toggle_theme"),
  },
}

--------------------------------------------------------------------------------
-- Events
--------------------------------------------------------------------------------

wezterm.on("toggle_book_mode", function(window, pane)
  local overrides = window:get_config_overrides() or {}

  if not book_mode then
    overrides.enable_tab_bar = false
    overrides.font = wezterm.font("Bitstream Vera Sans Mono")
    overrides.font_size = 9
    overrides.line_height = 1.4

    book_mode = true
  else
    overrides.enable_tab_bar = true
    overrides.font = nil
    overrides.font_size = nil
    overrides.line_height = nil

    book_mode = false
  end

  window:set_config_overrides(overrides)
end)

wezterm.on("toggle_theme", function(window, pane)
  local overrides = window:get_config_overrides() or {}

  -- Theme
  if current_theme == #themes then
    current_theme = 1
  else
    current_theme = current_theme + 1
  end

  overrides.color_scheme = themes[current_theme]

  -- Tabbar
  local scheme = wezterm.color.get_builtin_schemes()[overrides.color_scheme]

  overrides.colors = {
    tab_bar = {
      background = scheme.background,

      active_tab = {
        bg_color = scheme.ansi[5],
        fg_color = scheme.background,
      },

      inactive_tab = {
        bg_color = scheme.background,
        fg_color = scheme.foreground,
      },

      inactive_tab_hover = {
        bg_color = "#f8f8f8",
        fg_color = "#272727",
      },

      new_tab = {
        bg_color = scheme.background,
        fg_color = scheme.ansi[5],
      },

      new_tab_hover = {
        bg_color = "#f8f8f8",
        fg_color = "#272727",
      },
    },

    scrollbar_thumb = config.colors.scrollbar_thumb,
  }

  -- Apply
  window:set_config_overrides(overrides)
end)

return config
