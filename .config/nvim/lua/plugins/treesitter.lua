return {
    {
        'nvim-treesitter/nvim-treesitter',
        build = ":TSUpdate",
        cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
        keys = {
            { "<c-space>", desc = "Increment Selection" },
            { "<bs>", desc = "Decrement Selection", mode = "x" },
        },
        config = function()
            local configs = require("nvim-treesitter.configs")

            configs.setup({
              highlight = {
                enable = true,
                disable = {},
                additional_vim_regex_highlighting = false,
              },
              indent = {
                enable = false,
                disable = {},
              },
              sync_install = false,
              auto_install = true,
              ensure_installed = {
                "c",
                "go",
                "gomod",
                "lua",
                "perl",
                "python",
                "javascript",
                "typescript",
                "bash",
                "vim",
                "vimdoc",
                "make",
                "markdown",
                "markdown_inline",
                "json",
                "yaml",
                "helm",
                "hcl",
                "dockerfile",
            },

            -- textobjects = {
            --     select = {
            --         enable = true,
            --         lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            --         keymaps = {
            --             ["af"] = { query = "@function.outer", desc = "Select outer part of a function" },
            --             ["if"] = { query = "@function.inner", desc = "Select inner part of a function" },
            --             ["ac"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
            --             ["ic"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },
            --             ["ab"] = { query = "@block.outer", desc = "Select outer part of a block" },
            --             ["ib"] = { query = "@block.inner", desc = "Select inner part of a block" },
            --         },
            --     },
            --     swap = {
            --         enable = true,
            --         swap_next = {
            --             ["<leader>a"] = "@parameter.inner",
            --         },
            --         swap_previous = {
            --             ["<leader>A"] = "@parameter.inner",
            --         },
            --     },
            --     move = {
            --         enable = true,
            --         set_jumps = true, -- whether to set jumps in the jumplist
            --         goto_next_start = {
            --             ["]]"] = "@function.outer",
            --         },
            --         goto_next_end = {
            --             ["]["] = "@function.outer",
            --         },
            --         goto_previous_start = {
            --             ["[["] = "@function.outer",
            --         },
            --         goto_previous_end = {
            --             ["[]"] = "@function.outer",
            --         },
            --     },
            -- },
        })
    end
    },

    {
        "nvim-treesitter/nvim-treesitter-context",
        cmd = { "TSContextEnable", "TSContextDisable", "TSContextToggle" },
        config = function()
            vim.keymap.set("n", "[c", function()
                require("treesitter-context").go_to_context(vim.v.count1)
            end, { silent = true })
        end,
    },

    -- {
    --     "nvim-treesitter/nvim-treesitter-textobjects",
    -- },
}
