return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim"
        },
        keys = {
            { '<leader>ff', function() require("telescope.builtin").find_files() end, desc = '[F]ind [F]iles' },
            { '<leader>fb', function() require("telescope.builtin").buffers() end, desc = '[F]ind [B]uffers' },
            { '<leader>fg', function() require("telescope.builtin").live_grep() end, desc = '[F]ind using [G]rep' },
            { '<leader>fw', function() require("telescope.builtin").grep_string() end , desc = '[F]ind current [W]ord' },
            { '<leader>fh', function() require("telescope.builtin").help_tags() end , desc = '[F]ind [H]elp' },

            { '<leader>fr', function() require("telescope.builtin").lsp_references() end, desc = 'LSP: [F]ind [R]eferences' },
            { '<leader>fd', function() require("telescope.builtin").lsp_definitions() end, desc = 'LSP: [F]ind [D]efinitions' },
            { '<leader>ft', function() require("telescope.builtin").lsp_type_definition() end, desc = 'LSP: [F]ind [T]ype definitions' },
            { '<leader>fi', function() require("telescope.builtin").lsp_implementations() end, desc = 'LSP: [F]ind [I]mplementations' },
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
        end,
    },
}
