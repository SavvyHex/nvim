local function on_attach(bufnr)
  local api = require("nvim-tree.api")

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- Keep all default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- Add custom keybinding: 'l' to open/edit file
  vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))

  -- Optional: 'h' to close folder
  vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close Directory'))
end

return {
  hijack_netrw = true,
  sync_root_with_cwd = true,
  respect_buf_cwd = true,

  on_attach = on_attach,

  view = {
    width = 30,
    side = "left",
  },

  update_focused_file = {
    enable = true,
    update_root = true,
  },
}
