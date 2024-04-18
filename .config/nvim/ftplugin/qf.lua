vim.keymap.set('n', 'q', '<cmd>q<cr>', { silent = true, buffer = true })
-- close window when an entry is selected
vim.keymap.set('n', '<cr>', '<cr><cmd>cclose<cr>', { buffer = true })
