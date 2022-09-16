require('telescope').setup{
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
