vim.opt.expandtab = true
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.tabstop = 8

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.smartindent = true

vim.opt.swapfile = true
vim.opt.backup = false
vim.opt.undodir = vim.fn.stdpath("state") .. "undo"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.suffixes:append { ",," }
vim.opt.wildignore = { "*~", "*.a", "*.o", "*.so", "*.pyc", "*.jpg", "*.jpeg", "*.png", "*.gif", "*.pdf", "*.git", "*.swp", "*.swo" }
vim.opt.wildmode = { "list", "list:longest", "full" }

vim.opt.completeopt = { "menuone", "noinsert", "noselect" }

vim.opt.mouse = ""

vim.opt.dictionary = "/usr/share/dict/words"

vim.opt.formatoptions = "trqjl/"

vim.opt.listchars = "tab:»·,trail:␣,nbsp:˷"

vim.opt.signcolumn = "yes"

vim.opt.switchbuf = "useopen"

vim.opt.termguicolors = true

vim.opt.updatetime = 50

vim.opt.scrolloff = 4
