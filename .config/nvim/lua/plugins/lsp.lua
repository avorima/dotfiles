return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "mason-org/mason.nvim",
            "mason-org/mason-lspconfig.nvim",
        },
        config = function()
            vim.lsp.config("efm", {
                settings = {
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
                }
            })

            vim.lsp.config("gopls", {
                settings = {
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
                            checkThirdPart = false,
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
