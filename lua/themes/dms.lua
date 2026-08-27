-- ~/.config/nvim/lua/themes/dms.lua
--
-- DMS / Kitty -> NvChad Base46 theme
--
-- Source:
--   ~/.config/kitty/dank-theme.conf
--
-- Expected format:
--   foreground #xxxxxx
--   background #xxxxxx
--   color0     #xxxxxx
--   ...
--   color15    #xxxxxx

local M = {}

local theme_file = vim.fn.expand("~/.config/kitty/dank-theme.conf")

local function read_kitty_colors()
  local colors = {}

  local file = io.open(theme_file, "r")
  if not file then
    return colors
  end

  for line in file:lines() do
    local name, color = line:match("^%s*(%S+)%s+(#%x%x%x%x%x%x)%s*$")

    if name and color then
      colors[name] = color
    end
  end

  file:close()

  return colors
end

local c = read_kitty_colors()

-- Fallbacks make Neovim start even if DMS hasn't generated the file yet.
local function color(name, fallback)
  return c[name] or fallback
end

-- Kitty -> Base16
--
-- Base16:
--   base00 = background
--   base01 = darker background
--   base02 = selection / lighter background
--   base03 = comments / muted
--   base04 = dark foreground
--   base05 = foreground
--   base06 = light foreground
--   base07 = brightest foreground
--   base08 = red
--   base09 = orange
--   base0A = yellow
--   base0B = green
--   base0C = cyan
--   base0D = blue
--   base0E = purple
--   base0F = extra accent
M.base_16 = {
  base00 = color("background", "#1d2021"),
  base01 = color("color0", "#141617"),
  base02 = color("color8", "#7a7c73"),
  base03 = color("color8", "#7a7c73"),
  base04 = color("color7", "#bdbfb3"),
  base05 = color("foreground", "#ddc7a1"),
  base06 = color("color15", "#fdfff8"),
  base07 = color("color15", "#fdfff8"),

  base08 = color("color1", "#d16e5e"),
  base09 = color("color3", "#e3d166"),
  base0A = color("color11", "#fff1a5"),
  base0B = color("color2", "#64b65b"),
  base0C = color("color6", "#a8b665"),
  base0D = color("color4", "#9cac50"),
  base0E = color("color5", "#48540f"),
  base0F = color("color13", "#dfeca2"),
}

-- Base30 is what NvChad's UI uses.
M.base_30 = {
  white = color("color15", "#fdfff8"),
  black = color("background", "#1d2021"),
  darker_black = color("color0", "#141617"),

  black2 = color("color0", "#141617"),

  one_bg = color("color8", "#7a7c73"),
  one_bg2 = color("color8", "#7a7c73"),
  one_bg3 = color("color7", "#bdbfb3"),

  grey = color("color8", "#7a7c73"),
  grey_fg = color("color7", "#bdbfb3"),
  grey_fg2 = color("color7", "#bdbfb3"),
  light_grey = color("color15", "#fdfff8"),

  red = color("color1", "#d16e5e"),
  baby_pink = color("color9", "#f5a699"),
  pink = color("color9", "#f5a699"),

  line = color("color8", "#7a7c73"),

  green = color("color2", "#64b65b"),
  vibrant_green = color("color10", "#95da8d"),

  nord_blue = color("color4", "#9cac50"),
  blue = color("color4", "#9cac50"),
  seablue = color("color6", "#a8b665"),

  yellow = color("color3", "#e3d166"),
  sun = color("color11", "#fff1a5"),

  purple = color("color5", "#48540f"),
  dark_purple = color("color5", "#48540f"),

  teal = color("color6", "#a8b665"),
  orange = color("color3", "#e3d166"),
  cyan = color("color14", "#f5fecb"),

  statusline_bg = color("background", "#1d2021"),
  lightbg = color("color0", "#141617"),
  pmenu_bg = color("color0", "#141617"),
  folder_bg = color("color4", "#9cac50"),
}

-- Extra highlight adjustments.
--
-- These are intentionally based on the Base46 colors above rather than
-- hardcoding the DMS palette, so they remain dynamic.
M.polish_hl = {
  defaults = {
    Comment = {
      fg = M.base_30.grey,
      italic = true,
    },

    Cursor = {
      fg = color("cursor_text_color", "#d4be98"),
      bg = color("cursor", "#ddc7a1"),
    },

    Visual = {
      fg = color("selection_foreground", "#141617"),
      bg = color("selection_background", "#d7a657"),
    },

    Search = {
      fg = color("selection_foreground", "#141617"),
      bg = color("selection_background", "#d7a657"),
    },

    IncSearch = {
      fg = color("selection_foreground", "#141617"),
      bg = color("color11", "#fff1a5"),
    },

    CurSearch = {
      fg = color("selection_foreground", "#141617"),
      bg = color("color11", "#fff1a5"),
    },

    LineNr = {
      fg = M.base_30.grey,
    },

    CursorLineNr = {
      fg = M.base_30.yellow,
      bold = true,
    },

    Directory = {
      fg = M.base_30.folder_bg,
    },

    ErrorMsg = {
      fg = M.base_30.red,
    },

    WarningMsg = {
      fg = M.base_30.yellow,
    },

    MoreMsg = {
      fg = M.base_30.green,
    },

    ModeMsg = {
      fg = M.base_30.green,
    },
  },

  treesitter = {
    ["@comment"] = {
      fg = M.base_30.grey,
      italic = true,
    },

    ["@string"] = {
      fg = M.base_30.green,
    },

    ["@number"] = {
      fg = M.base_30.orange,
    },

    ["@boolean"] = {
      fg = M.base_30.orange,
    },

    ["@constant"] = {
      fg = M.base_30.yellow,
    },

    ["@function"] = {
      fg = M.base_30.blue,
    },

    ["@function.call"] = {
      fg = M.base_30.blue,
    },

    ["@keyword"] = {
      fg = M.base_30.purple,
    },

    ["@type"] = {
      fg = M.base_30.cyan,
    },

    ["@type.builtin"] = {
      fg = M.base_30.cyan,
    },

    ["@variable"] = {
      fg = M.base_30.white,
    },

    ["@property"] = {
      fg = M.base_16.base04,
    },

    ["@operator"] = {
      fg = M.base_30.purple,
    },

    ["@punctuation.bracket"] = {
      fg = M.base_30.grey_fg,
    },

    ["@punctuation.delimiter"] = {
      fg = M.base_30.grey_fg,
    },
  },
}

M.type = "dark"

return M

