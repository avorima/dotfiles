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
        "toppair/peek.nvim",
        build = "deno task --quiet build:fast",
        opts = {
            auto_load = false,
            app = { "chromium", "--new-window" }
        },
        keys = {
            {
                "<F6>",
                function()
                    local peek = require("peek")
                    if peek.is_open() then
                        peek.close()
                    else
                        peek.open()
                    end
                end
            },
        },
    },

    {
        "hedyhli/markdown-toc.nvim",
        ft = "markdown",
        cmd = { "Mtoc" },
        opts = {
        },
    },
}
