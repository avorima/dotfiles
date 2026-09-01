local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local dev_group = augroup("Development", {})
local security_group = augroup("Security", {})
local global_group = augroup("Global", {})
local filetype_group = augroup("Filetypes", {})
local visual_group = augroup("Visual", {})

autocmd({ "BufNewFile", "BufRead" }, {
    group = security_group,
    pattern = {
        "/dev/shm/gopass.*",
        ".netrc",
        "~/.docker/",
        ".envrc",
        "*kubeconfig*",
        "~/.kube/*",
        "/tmp/kubectl-edit*.yaml",
        "~/.ssh/*",
        "~/.ssl/*",
        "*.key",
        "*.pem",
        "*.crt",
        "id_*",
    },
    callback = function(_)
        vim.opt_local.swapfile = false
        vim.opt_local.backup = false
        vim.opt_local.undofile = false
    end,
    desc = "Don't make copies of secrets",
})

autocmd("LspAttach", {
    group = dev_group,
    callback = function(ev)
        local opts = { silent = true, buffer = ev.buf }

        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
        vim.keymap.set("n", "<bs><bs>", function() vim.lsp.buf.format({ async = true }) end, opts)
    end,
    desc = "Set up LSP bindings",
})

autocmd("BufNewFile", {
    group = global_group,
    callback = function(_)
        local dirname = vim.fn.expand("%:p:h")
        if vim.fn.isdirectory(dirname) == 0 then
            vim.ui.select({ "yes", "no" }, {
                prompt = string.format("Create intermediate directory '%s'?", dirname)
            }, function(choice)
                if choice == "yes" then
                    vim.fn.mkdir(dirname, "p")
                end
            end)
        end
    end,
    desc = "Create intermediate directory",
})

autocmd("BufWritePost", {
    group = global_group,
    callback = function(_)
        local filename = vim.fn.expand("%:p")
        if vim.fs.ext(filename) ~= 'sh' then
            return
        end
        local mode = vim.uv.fs_stat(filename).mode
        local bit = require("bit")
        local exec_flag = tonumber("100", 8)
        if bit.band(mode, exec_flag) ~= exec_flag then
            vim.uv.fs_chmod(filename, bit.bor(mode, exec_flag))
        end
    end,
    desc = "Ensure files are executable",
})

autocmd("BufReadPost", {
    group = global_group,
    command = [[if &ft !~# 'commit\|rebase' && line("'\"") > 1 && line("'\"") <= line("$") | exe 'normal! g`"' | endif]],
    desc = "Continue at last position",
})

autocmd({ "BufNewFile", "BufRead" }, {
    group = filetype_group,
    pattern = { ".envrc" },
    command = "setfiletype sh",
})

autocmd("ColorScheme", {
    group = visual_group,
    command = "highlight link TreesitterContextLineNumber CursorLineNr",
    pattern = "*",
    desc = "Configure nvim-treesitter-context highlights",
})
