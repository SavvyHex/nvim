local M = {}

local theme_file = vim.fn.expand("~/.config/kitty/dank-theme.conf")

local function read_colors()
  local colors = {}

  for line in io.lines(theme_file) do
    local name, color = line:match("^%s*(%S+)%s+(#%x%x%x%x%x%x)%s*$")

    if name and color then
      colors[name] = color
    end
  end

  return colors
end

function M.apply()
  local c = read_colors()

  if not c.background then
    return
  end

  local set = vim.api.nvim_set_hl

  set(0, "Normal", {
    fg = c.foreground,
    bg = c.background,
  })

  set(0, "NormalFloat", {
    fg = c.foreground,
    bg = c.color0,
  })

  set(0, "Comment", {
    fg = c.color8,
    italic = true,
  })

  set(0, "String", {
    fg = c.color2,
  })

  set(0, "Function", {
    fg = c.color4,
  })

  set(0, "Keyword", {
    fg = c.color5,
  })

  set(0, "Type", {
    fg = c.color6,
  })

  set(0, "Constant", {
    fg = c.color3,
  })

  set(0, "Number", {
    fg = c.color3,
  })

  set(0, "Identifier", {
    fg = c.foreground,
  })

  set(0, "Operator", {
    fg = c.color1,
  })

  set(0, "Cursor", {
    fg = c.cursor_text_color,
    bg = c.cursor,
  })

  set(0, "Visual", {
    fg = c.selection_foreground,
    bg = c.selection_background,
  })

  set(0, "LineNr", {
    fg = c.color8,
  })

  set(0, "CursorLineNr", {
    fg = c.color3,
    bold = true,
  })

  set(0, "DiagnosticError", {
    fg = c.color1,
  })

  set(0, "DiagnosticWarn", {
    fg = c.color3,
  })

  set(0, "DiagnosticInfo", {
    fg = c.color4,
  })

  set(0, "DiagnosticHint", {
    fg = c.color6,
  })
end

return M

