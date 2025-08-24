return {
    {
        "folke/which-key.nvim",
        opts = {
            spec = {
                { "<BS>",      desc = "Decrement Selection", mode = "x" },
                { "<c-space>", desc = "Increment Selection", mode = { "x", "n" } },
            },
        },
    },

    {
        "rgroli/other.nvim",
        opts = {
            mappings = {
                "c",
                "golang",
            },
        },
        main = "other-nvim",
        keys = {
            { "<leader>ao", "<cmd>Other<cr>",       mode = "n", desc = "Alternate Edit", },
            { "<leader>as", "<cmd>OtherSplit<cr>",  mode = "n", desc = "Alternate Split", },
            { "<leader>av", "<cmd>OtherVSplit<cr>", mode = "n", desc = "Alternate VSplit", },
            { "<A-s>",      "<cmd>OtherSplit<cr>",  mode = "i", desc = "Alternate Split", },
            { "<A-v>",      "<cmd>OtherVSplit<cr>", mode = "i", desc = "Alternate VSplit", },
        },
    },

    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({})
        end
    },

    {
        "hedyhli/markdown-toc.nvim",
        ft = "markdown",
        cmd = { "Mtoc" },
        opts = {
        },
    },

    {
        "junegunn/vim-easy-align",
        lazy = false,
        keys = {
            { "ga", "<Plug>(EasyAlign)", mode = "x" },
        },
        config = function()
            vim.g.easy_align_ignore_groups = { 'Comment', 'String' }
        end,
    },

    {
        "johmsalas/text-case.nvim",
        keys = {
            { "crs", function() require("textcase").current_word("to_snake_case") end, },
            { "crc", function() require("textcase").current_word("to_camel_case") end, },
            { "crp", function() require("textcase").current_word("to_pascal_case") end, },
            { "cr-", function() require("textcase").current_word("to_dash_case") end, },
        },
        config = function()
            require("textcase").setup({
                default_keymappings_enabled = false
            })
        end,
        lazy = true,
    },

    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
            "nvim-telescope/telescope.nvim",
        },
        config = true
    },

    {
        "lambdalisue/vim-suda",
    },
}
