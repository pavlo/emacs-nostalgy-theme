-- Nostalgy for WezTerm -- the parts a colour scheme file cannot carry.
--
-- `nostalgy.toml' colours the terminal grid, cursor, selection, scrollbar,
-- split lines and the *retro* tab bar.  The default *fancy* tab bar and the
-- window frame around it are styled by `window_frame', which lives only in
-- Lua -- hence this helper.
--
-- Usage in ~/.config/wezterm/wezterm.lua:
--
--     local wezterm = require 'wezterm'
--     local config = wezterm.config_builder()
--
--     -- make this file requireable (adjust the path to where you cloned it)
--     package.path = wezterm.home_dir
--       .. '/src/emacs-nostalgy-theme/wezterm/?.lua;' .. package.path
--
--     require('nostalgy').apply(config)
--     -- or, for the full palette on the tabs themselves:
--     -- require('nostalgy').apply(config, { retro_tab_bar = true })
--
--     return config

local M = {}

M.scheme = 'Nostalgy'

-- Echoes nostalgy-theme's bg-tab-bar / mode-line / border tokens.
M.window_frame = {
  active_titlebar_bg = '#274040',
  inactive_titlebar_bg = '#243c3c',
  active_titlebar_fg = '#f5deb3',
  inactive_titlebar_fg = '#9db0b0',
  active_titlebar_border_bottom = '#41615f',
  inactive_titlebar_border_bottom = '#41615f',
  button_bg = '#274040',
  button_fg = '#b3ac8f',
  button_hover_bg = '#476d6d',
  button_hover_fg = '#f5deb3',
}

-- The fancy tab bar picks the per-tab colours from here; the retro bar
-- takes everything (including the bar background) from nostalgy.toml.
M.tab_bar = {
  background = '#274040',
  inactive_tab_edge = '#41615f',
  active_tab = { bg_color = '#2f4f4f', fg_color = '#f5deb3' },
  inactive_tab = { bg_color = '#385959', fg_color = '#b3ac8f' },
  inactive_tab_hover = { bg_color = '#476d6d', fg_color = '#f5deb3', italic = true },
  new_tab = { bg_color = '#274040', fg_color = '#b3ac8f' },
  new_tab_hover = { bg_color = '#476d6d', fg_color = '#f5deb3', italic = true },
}

--- Apply the Nostalgy look to a WezTerm config table.
--- @param config table                       config builder or plain table
--- @param opts   table|nil   { retro_tab_bar = boolean }  default: fancy bar
--- @return table config
function M.apply(config, opts)
  opts = opts or {}
  config.color_scheme = M.scheme
  config.window_frame = M.window_frame
  config.colors = config.colors or {}
  config.colors.tab_bar = M.tab_bar
  if opts.retro_tab_bar then
    config.use_fancy_tab_bar = false
  end
  return config
end

return M
