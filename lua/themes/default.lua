local uv = vim.loop
local M = {}

-- Path to the kitty color JSON
local kitty_colors_path = "/home/savvyhex/.local/state/quickshell/user/generated/colors.json"

-- Read the file safely and decode JSON
local function read_colors()
  local fd = uv.fs_open(kitty_colors_path, "r", 438)
  if not fd then
    return nil
  end

  local stat = uv.fs_fstat(fd)
  local data = uv.fs_read(fd, stat.size, 0)
  uv.fs_close(fd)

  if not data then
    return nil
  end

  local ok, parsed = pcall(vim.fn.json_decode, data)
  if not ok then
    return nil
  end

  return parsed
end

local kitty = read_colors() or {}

-- Provide a few sensible fallbacks when keys are missing
local fallback = {
  background = "#1e1e2e",
  foreground = "#cdd6f4",
  color0 = "#45475a",
  color1 = "#f38ba8",
  color2 = "#a6e3a1",
  color3 = "#f9e2af",
  color4 = "#89b4fa",
  color5 = "#f5c2e7",
  color6 = "#94e2d5",
  color7 = "#bac2de",
  color8 = "#585b70",
  color9 = "#f38ba8",
  color10 = "#a6e3a1",
  color11 = "#f9e2af",
  color12 = "#89b4fa",
  color13 = "#f5c2e7",
  color14 = "#94e2d5",
  color15 = "#a6adc8",
}

-- Helper: try multiple keys (in order) and return first present, else fallback
local function pick(keys, fb)
  for _, k in ipairs(keys) do
    if kitty[k] then
      return kitty[k]
    end
  end

  -- try common nested 'colors' table
  if kitty.colors and type(kitty.colors) == "table" then
    for _, k in ipairs(keys) do
      if kitty.colors[k] then
        return kitty.colors[k]
      end
    end
  end

  -- fallback to provided fallback value or a sensible default
  if fb then return fb end
  return fallback[keys[1]] or "#000000"
end

-- Map the kitty JSON to base46 fields. We try to use the most semantically appropriate keys
-- but fall back gracefully when fields are missing.
-- Use the terminal background as the canonical editor background where appropriate
local term_bg = pick({"background", "surface", "surface_dim", "color0"}, "#1e1e2e")

M.base_30 = {
  white = pick({"foreground", "on_background", "on_surface", "color15"}, "#ffffff"),
  darker_black = pick({"surface_container_lowest", "surface_container_low", "surface"}, "#0f0f0f"),
  -- make editor area backgrounds match the terminal background
  black = term_bg,
  black2 = term_bg,
  one_bg = term_bg,
  one_bg2 = term_bg,
  one_bg3 = term_bg,
  grey = pick({"surface_variant", "outline_variant", "color8"}, "#888888"),
  grey_fg = pick({"on_surface_variant", "outline", "color7"}, "#444444"),
  light_grey = pick({"on_surface_variant", "color7"}, "#555555"),
  red = pick({"error", "primary", "color1"}, "#ff5f5f"),
  baby_pink = pick({"primary", "color9", "color1"}, "#ffb6c1"),
  pink = pick({"primary", "color5"}, "#ff87d7"),
  line = pick({"surface_container_low", "surface_dim", "color8"}, "#2e2e2e"),
  green = pick({"success", "tertiary", "color2"}, "#5fff87"),
  vibrant_green = pick({"tertiary_fixed_dim", "color10", "color2"}, "#00ff87"),
  nord_blue = pick({"surface_tint", "primary_container", "color4"}, "#5f87ff"),
  blue = pick({"surface_tint", "primary_container", "color4"}, "#5f87ff"),
  yellow = pick({"tertiary", "tertiary_container", "color3"}, "#ffff00"),
  sun = pick({"tertiary", "tertiary_container", "color11"}, "#ffff00"),
  purple = pick({"primary_fixed_dim", "color13", "color5"}, "#af87ff"),
  dark_purple = pick({"primary_fixed", "color5"}, "#875fff"),
  teal = pick({"secondary_fixed", "color6"}, "#00ffd7"),
  orange = pick({"tertiary_container", "secondary_container", "color11"}, "#ffaf5f"),
  cyan = pick({"secondary_fixed", "tertiary_fixed", "color12"}, "#5fd7ff"),
  statusline_bg = term_bg,
  lightbg = term_bg,
  pmenu_bg = pick({"primary_container", "surface_tint", "color4"}, "#5f87ff"),
  folder_bg = pick({"primary_container", "surface_tint", "color4"}, "#5f87ff"),
}

M.base_16 = {
  base00 = term_bg,
  base01 = pick({"surface_container_low", "surface_container"}, "#2e2e2e"),
  base02 = pick({"surface_container", "surface_container_low"}, "#3a3a3a"),
  base03 = pick({"surface_container_high", "surface_container"}, "#444444"),
  base04 = pick({"outline", "outline_variant", "color7"}, "#bfbfbf"),
  base05 = pick({"on_background", "on_surface", "foreground"}, "#cdd6f4"),
  base06 = pick({"on_background", "on_surface_variant", "color15"}, "#d0d0d0"),
  base07 = pick({"on_primary", "on_background", "color15"}, "#e0e0e0"),
  base08 = pick({"error", "primary", "color1"}, "#ff5f5f"),
  base09 = pick({"primary_container", "color11"}, "#f9e2af"),
  base0A = pick({"tertiary", "color3"}, "#f9e2af"),
  base0B = pick({"tertiary_fixed", "color2"}, "#a6e3a1"),
  base0C = pick({"secondary_fixed", "color6"}, "#94e2d5"),
  base0D = pick({"surface_tint", "color4"}, "#89b4fa"),
  base0E = pick({"primary_fixed_dim", "color5"}, "#f5c2e7"),
  base0F = pick({"primary_fixed", "color9"}, "#f38ba8"),
}

M.type = "dark"
-- Setup a watcher so the theme auto-updates when the kitty JSON changes.
-- We store the watcher in `_G.kitty_theme_watcher` so repeated requires/reloads
-- don't create multiple watchers.
local function setup_watcher()
  if _G.kitty_theme_watcher and _G.kitty_theme_watcher.start then
    return
  end

  -- Debounce helper
  local timer = nil
  local function on_change(err)
    if err then
      vim.schedule(function()
        vim.notify("kitty theme watcher error: " .. tostring(err), vim.log.levels.ERROR)
      end)
      return
    end

    if timer then
      timer:stop()
      timer:close()
      timer = nil
    end

    timer = vim.loop.new_timer()
    timer:start(150, 0, vim.schedule_wrap(function()
      -- Reload theme module and re-run base46 compile
      pcall(function()
        -- Clear loaded module so require will reload
        package.loaded["themes.default"] = nil
        package.loaded["custom.themes.default"] = nil
        local ok, _ = pcall(require, "themes.default")
        if not ok then
          vim.notify("Failed to reload themes.default after change", vim.log.levels.WARN)
          return
        end

        local ok2, _ = pcall(function()
          require("base46").load_all_highlights()
        end)

        if not ok2 then
          vim.notify("Failed to recompile highlights after theme change", vim.log.levels.WARN)
        else
          vim.notify("Kitty theme changed — reloaded Neovim highlights", vim.log.levels.INFO)
        end
      end)
    end))
  end

  local ev
  local ok, err = pcall(function()
    ev = uv.new_fs_event()
    ev:start(kitty_colors_path, {}, vim.schedule_wrap(function(err)
      on_change(err)
    end))
  end)

  if not ok then
    vim.notify("Could not start kitty colors watcher: " .. tostring(err), vim.log.levels.WARN)
    return
  end

  -- Keep a reference so it won't be GC'd and to avoid duplicates
  _G.kitty_theme_watcher = ev
end

-- Try to setup watcher (safe to call multiple times)
pcall(setup_watcher)

return M
