return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "mason-org/mason.nvim",
            "mason-org/mason-lspconfig.nvim",
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "clangd",
                    "gopls",
                    "lua_ls",
                    "rust_analyzer",
                    "vimls",
                    "efm",
                    "yamlls",
                }
            })

            vim.lsp.config("efm", {
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
                }
            })

            vim.lsp.config("gopls", {
                settings = {
                    gopls = {
                        buildFlags = { "-tags=e2e" },
                        directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
                        completeUnimported = true,
                        gofumpt = true,
                        staticcheck = true,
                        analyses = {
                            staticcheck = true,
                            unparam = true,
                            deadcode = true,
                            nilness = true,
                            typeparams = true,
                            unusedwrite = true,
                            unusedparams = true,
                            unusedresult = true,
                        },
                        hints = {
                            assignVariableTypes = true,
                            compositeLiteralFields = true,
                            compositeLiteralTypes = true,
                            constantValues = true,
                            functionTypeParameters = true,
                            parameterNames = true,
                            rangeVariableTypes = true,
                        },
                    },
                }
            })

            vim.lsp.config("lua_ls", {
                settings = {
                    Lua = {
                        runtime = {
                            version = "LuaJIT",
                        },
                        diagnostics = {
                            globals = { "vim" },
                        },
                        workspace = {
                            library = {
                                vim.env.VIMRUNTIME
                            }
                        },
                    },
                }
            })

            vim.lsp.config("yamlls", {
                settings = {
                    yaml = {
                        format = {
                            enable = true,
                        },
                        schemas = {
                            ["https://www.schemastore.org/github-workflow.json"] = { "/.github/workflows/*" },
                            ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.34.1-standalone-strict/all.json"] = {
                                "kubectl-*.yaml",
                                "/*.k8s.yaml",
                            },
                            ["https://www.schemastore.org/kustomization.json"] = { "kustomization.yaml" },
                            ["https://raw.githubusercontent.com/kyverno/chainsaw/main/.schemas/json/configuration-chainsaw-v1alpha1.json"] = { ".chainsaw.yaml" },
                            ["https://raw.githubusercontent.com/kyverno/chainsaw/main/.schemas/json/test-chainsaw-v1alpha1.json"] = { "chainsaw-test.yaml" },
                        }
                    }
                }
            })

            vim.lsp.config("pylsp", {
                settings = {
                    pylsp = {
                        plugins = {
                            pycodestyle = {
                                -- ignore = {"W391"},
                                maxLineLength = 120
                            }
                        }
                    }
                }
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
                    style     = "minimal",
                    border    = "rounded",
                    source    = true,
                    header    = "",
                    prefix    = "",
                },
            })
        end,
    },
}
