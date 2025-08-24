return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "clangd",
                    "gopls",
                    "pylsp",
                    "lua_ls",
                    "rust_analyzer",
                    "vimls",
                    "efm",
                    "yamlls",
                }
            })
            require("mason-lspconfig").setup_handlers({
                function(server_name)
                    require("lspconfig")[server_name].setup({})
                end,

                ["efm"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.efm.setup({
                        init_options = { documentFormatting = true },
                        filetypes = { "sh" },
                        settings = {
                            rootMarkers = { ".git/", ".config/" },
                            languages = {
                                sh = {
                                    {
                                        lintCommand = "shellcheck -f gcc -x",
                                        lintSource = "shellcheck",
                                        lintFormats = { "%f:%l:%c: %trror: %m", "%f:%l:%c: %tarning: %m",
                                            "%f:%l:%c: %tote: %m" },
                                    },
                                    {
                                        formatCommand = "shfmt -ci -s -bn -i 4",
                                        formatStdin = true,
                                    },
                                },
                            },
                        },
                    })
                end,

                ["gopls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.gopls.setup({
                        cmd = { "gopls", "serve" },
                        settings = {
                            gopls = {
                                gofumpt = true,
                                buildFlags = { "-tags=unit,integration,e2e" },
                                analyses = {
                                    unusedvariable = true,
                                    unusedwrite = true,
                                },
                            },
                        },
                    })
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup({
                        settings = {
                            Lua = {
                                runtime = {
                                    version = "LuaJIT",
                                },
                                diagnostics = {
                                    globals = { "vim" },
                                },
                                workspace = {
                                    checkThirdPart = false,
                                    library = {
                                        vim.env.VIMRUNTIME
                                    }
                                },
                            },
                        },
                    })
                end,

                ["yamlls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.yamlls.setup({
                        settings = {
                            yaml = {
                                format = {
                                    enable = true,
                                },
                                schemas = {
                                    ["https://json.schemastore.org/github-workflow.json"] = { "/.github/workflows/*" },
                                    ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.31.3-standalone-strict/all.json"] = {
                                        "kubectl-*.yaml",
                                        "/*.k8s.yaml",
                                    },
                                    ["http://json.schemastore.org/kustomization"] = { "kustomization.yaml" },
                                    ["https://raw.githubusercontent.com/kyverno/chainsaw/main/.schemas/json/configuration-chainsaw-v1alpha1.json"] = { ".chainsaw.yaml" },
                                    ["https://raw.githubusercontent.com/kyverno/chainsaw/main/.schemas/json/test-chainsaw-v1alpha1.json"] = { "chainsaw-test.yaml" },
                                }
                            }
                        }
                    })
                end,
            })

            -- vim.lsp.handlers["textDocument/publishDiagnostic"] = vim.lsp.with(
            --     vim.lsp.diagnostic.on_publish_diagnostics, {
            --         underline = true,
            --         virtual_text = {
            --             spacing = 4,
            --             prefix = ""
            --         },
            --     })

            vim.diagnostic.config({
                float = {
                    focusable = false,
                    style = "minimal",
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "",
                },
            })
        end,
    },
}
