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
