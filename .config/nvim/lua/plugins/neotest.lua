return {
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            "leoluz/nvim-dap-go",
            "uga-rosa/utf8.nvim",
            -- Adapters
            {
                -- "nvim-neotest/neotest-go",
                "fredrikaverpil/neotest-golang",
                version = "*",
                dependencies = {
                    "andythigpen/nvim-coverage",
                },
            },
        },
        keys = {
            {
                "<leader>tt",
                function()
                    require("neotest").run.run()
                    require("coverage").load()
                end,
                desc = "Test: Method"
            },
            {
                "<leader>tf",
                function()
                    require("neotest").run.run(vim.fn.expand("%"))
                    require("coverage").load()
                end,
                desc = "Test: File"
            },
            { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Test: Debug" },
            { "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Test: Show Output" },
            { "<leader>ts", function() require("neotest").summary.toggle() end,              desc = "Test: Show Summary" },
            { "<leader>tc", function() require("coverage").toggle() end,                     desc = "Test: Coverage" },
        },
        config = function()
            local golang_opts = {
                go_test_args = {
                    "-v",
                    "-count=1",
                    "-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out",
                    "-tags=e2e",
                },
                go_list_args = { "-tags=e2e" },
                dap_go_opts = {
                    delve = {
                        build_flags = { "-tags=e2e" },
                    },
                },
                dap_go_enabled = true,
                testify_enabled = true,
                warn_test_name_dupes = false,
                sanitize_output = true,
                log_level = vim.log.levels.DEBUG,
            }
            require("neotest").setup({
                adapters = {
                    require("neotest-golang")(golang_opts)
                },
            })
        end,
    },

    {
        "andythigpen/nvim-coverage",
        config = function()
            require("coverage").setup()
        end,
    },
}
