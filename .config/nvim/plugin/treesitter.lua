require'nvim-treesitter.configs'.setup {
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
    "make",
    "markdown",
    "markdown_inline",
    "json",
    "yaml",
    "hcl",
    "dockerfile"
  },
}
