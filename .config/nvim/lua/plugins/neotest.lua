return {
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            -- Adapters
            { "fredrikaverpil/neotest-golang", version = "*" },
        },
        keys = {
            { "<leader>tt", function() require("neotest").run.run() end,                     desc = "Test: Method" },
            { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end,   desc = "Test: File" },
            { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Test: Debug" },
            { "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Test: Show Output" },
        },
        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-golang"),
                },
                testify_enabled = true,
            })
        end,
    },
}
