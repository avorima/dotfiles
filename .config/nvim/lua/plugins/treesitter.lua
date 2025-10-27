return {
    {
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            "nvim-treesitter/nvim-treesitter-context",
        },
        lazy = false,
        branch = "main",
        build = ":TSUpdate",
        cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
        -- keys = {
        --     { "<c-space>", desc = "Increment Selection" },
        --     { "<bs>",      desc = "Decrement Selection", mode = "x" },
        -- },
        opts = {
            ensure_installed = {
                "go", "gomod", "gowork", "gosum",
            },
        },
    },

    {
        "nvim-treesitter/nvim-treesitter-context",
        opts = {
            mode = "cursor",
            max_lines = 3,
        },
    },
}
