return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            "williamboman/mason.nvim",
            "jay-babu/mason-nvim-dap.nvim",
            "leoluz/nvim-dap-go",
        },
        keys = {
            { "<F1>",       function() require("dap").step_into() end,         desc = "Debug: Step Into", },
            { "<F2>",       function() require("dap").step_over() end,         desc = "Debug: Step Over", },
            { "<F3>",       function() require("dap").step_out() end,          desc = "Debug: Step Out", },
            { "<leader>dr", function() require("dap").continue() end,          desc = "Debug: Start/Continue" },
            { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint" },
            { "<F7>",       function() require("dapui").toggle() end,          desc = "Debug: See last session result.", },
            { "<leader>dt", function() require("dap-go").debug_test() end,     desc = "Debug: Go Test" },
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            require("mason-nvim-dap").setup({
                automatic_intallation = true,
                handlers = {},
                ensure_installed = {
                    "delve",
                },
            })

            dapui.setup({
                icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
                controls = {
                    icons = {
                        pause = "⏸",
                        play = "▶",
                        step_into = "⏎",
                        step_over = "⏭",
                        step_out = "⏮",
                        step_back = "b",
                        run_last = "▶▶",
                        terminate = "⏹",
                        disconnect = "⏏",
                    },
                },
            })

            dap.listeners.after.event_initialized["dapui_config"] = dapui.open
            dap.listeners.before.event_terminated["dapui_config"] = dapui.close
            dap.listeners.before.event_exited["dapui_config"] = dapui.close

            require("dap-go").setup({})
        end,
    },
}
