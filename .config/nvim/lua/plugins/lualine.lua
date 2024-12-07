return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        opts = {
            options = {
                icons_enabled = true,
                theme = 'auto',
                component_separators = { left = '', right = ''},
                section_separators = { left = '', right = ''}
            },
            sections = {
                lualine_a = {'mode'},
                lualine_b = {
                    'branch',
                    'diff',
                    {
                        'diagnostics',
                        sources = { "nvim_lsp" },
                        symbols = {error = ' ', warn = ' ', info = ' ', hint = ' '}
                    },
                },
                lualine_c = {'filename'},
                lualine_x = {
                    'encoding',
                    'filetype'
                },
                lualine_y = {'progress'},
                lualine_z = {'location'}
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {'filename'},
                lualine_x = {'location'},
                lualine_y = {},
                lualine_z = {}
            },
            tabline = {},
        },
    },
}
