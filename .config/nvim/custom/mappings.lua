local M = {}

M.general = {
  n = {
    ["<leader>["] = { "moO<ESC>`o", "Add newline above cursor" },
    ["<leader>]"] = { "moo<ESC>`o", "Add newline below cursor" },
  },

  v = {
    ["<leader>y"] = { "\"*y", "Yank to system clipboard" },
  },
}

return M
