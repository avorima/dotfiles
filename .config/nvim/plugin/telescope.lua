require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
  pickers = {
    find_files = {
      theme = 'dropdown',
      previewer = false,
    },
    lsp_references = {
      theme = 'ivy',
    },
    lsp_definitions = {
      theme = 'ivy',
    },
    lsp_type_definitions = {
      theme = 'ivy',
    },
    lsp_implementations = {
      theme = 'ivy',
    },
  },
}

vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = '[F]ind [F]iles' })
vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, { desc = '[F]ind using [G]rep' })
vim.keymap.set('n', '<leader>fw', require('telescope.builtin').grep_string, { desc = '[F]ind current [W]ord' })
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = '[F]ind [H]elp' })

vim.keymap.set('n', '<leader>fr', require('telescope.builtin').lsp_references, { desc = 'LSP: [F]ind [R]eferences' })
vim.keymap.set('n', '<leader>fd', require('telescope.builtin').lsp_definitions, { desc = 'LSP: [F]ind [D]efinitions' })
vim.keymap.set('n', '<leader>ft', require('telescope.builtin').lsp_type_definitions, { desc = 'LSP: [F]ind [T]ype definitions' })
vim.keymap.set('n', '<leader>fi', require('telescope.builtin').lsp_implementations, { desc = 'LSP: [F]ind [I]mplementations' })
