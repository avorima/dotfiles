require("config.settings")
require("config.mappings")
require("config.lazy")
require("config.autocmd")

vim.filetype.add({
    extension = {
        gotmpl = "gotmpl",
    },
    pattern = {
        [".*/templates/.*%.tpl"] = "helm",
        [".*/templates/.*%.ya?ml"] = "helm",
        ["helmfile.*%.ya?ml"] = "helm",
    },
})

local function on_jump(diagnostic, bufnr)
    if not diagnostic then return end

    vim.diagnostic.show(
        diagnostic.namespace,
        bufnr,
        { diagnostic },
        { virtual_lines = { current_line = true }, virtual_text = false }
    )
end

vim.diagnostic.config({ jump = { on_jump = on_jump } })
