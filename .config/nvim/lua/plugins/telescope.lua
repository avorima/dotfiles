return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim"
        },
        config = function()
            require("telescope").setup({
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
                extensions = {
                    undo = {
                        side_by_side = true,
                        layout_strategy = "vertical",
                        layout_config = {
                            preview_height = 0.8,
                        },
                    },
                },
            })

            local builtin = require("telescope.builtin")

            vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[F]ind [F]iles' })
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[F]ind using [G]rep' })
            vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = '[F]ind current [W]ord' })
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[F]ind [H]elp' })

            vim.keymap.set('n', '<leader>fr', builtin.lsp_references, { desc = 'LSP: [F]ind [R]eferences' })
            vim.keymap.set('n', '<leader>fd', builtin.lsp_definitions, { desc = 'LSP: [F]ind [D]efinitions' })
            vim.keymap.set('n', '<leader>ft', builtin.lsp_type_definitions, { desc = 'LSP: [F]ind [T]ype definitions' })
            vim.keymap.set('n', '<leader>fi', builtin.lsp_implementations, { desc = 'LSP: [F]ind [I]mplementations' })
        end,
    },
}
