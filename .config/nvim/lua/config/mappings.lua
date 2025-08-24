local map = function(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
end

local noremap = function(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.noremap = true
    map(mode, lhs, rhs, opts)
end

map("n", "<space>", "")
vim.g.mapleader = " "
vim.g.maplocalleader = " "

map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = "Down" })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = "Down" })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "Up" })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "Up" })

map("n", "]e", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "[e", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "]e", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "[e", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>ba", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })

map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

map("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

map("n", "[q", "<cmd>cprev<cr>zv", { desc = "Previous Quickfix" })
map("n", "]q", "<cmd>cnext<cr>zv", { desc = "Next Quickfix" })

map("n", "[l", "<cmd>lprev<cr>zv", { desc = "Previous Location" })
map("n", "]l", "<cmd>lnext<cr>zv", { desc = "Next Location" })

map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev Diagnostic" })

map("n", "]<space>", ":<C-u>call append(line('.'),   repeat([''], v:count1))<cr>", { desc = "Add Newline Above" })
map("n", "[<space>", ":<C-u>call append(line('.')-1, repeat([''], v:count1))<cr>", { desc = "Add Newline Above" })

map("v", "<leader>eb", "c<c-r>=system('base64 -w0', @\")<cr><esc>", { desc = "Base64 Encode Selection" })
map("v", "<leader>db", "c<c-r>=system('base64 -d', @\")<cr><esc>", { desc = "Base64 Decode Selection" })

map("n", "+", "<C-a>", { desc = "Increment" })
map("n", "-", "<C-x>", { desc = "Decrement" })

map("n", "<leader><C-a>", "gg<S-v>G", { desc = "Select All" })

map("x", "<leader>s", ":s/\\%V", { silent = false, desc = "Replace In Selection" })

map("n", "<leader>s", ":s/\\C\\<<C-r><C-w>\\>//g<left><left>", { silent = false, desc = "Replace Word (Line)" })
map("n", "<leader>S", ":%s/\\C\\<<C-r><C-w>\\>//g<left><left>", { silent = false, desc = "Replace Word (Global)" })

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- Better indenting
map("v", "<", "<gv^")
map("v", ">", ">gv^")

-- Paste things continuously
map("x", "p", "\"_dP")

-- Yank to system clipboard
map("v", "<leader>y", "\"+y")

-- Don't keep short jumps in jumplist and keep centered
map("n", "}", ":<C-u>execute \"keepjumps norm! \" . v:count1 . \"}zz\"<CR>")
map("n", "{", ":<C-u>execute \"keepjumps norm! \" . v:count1 . \"{zz\"<CR>")

local insert_command = function()
    local cmd = nil
    vim.ui.input({ prompt = "Command: ", completion = "shellcmd" }, function(input)
        if input then
            cmd = vim.split(input, " ")
        end
    end)
    if cmd then
        local obj = vim.system(cmd, { text = true, timeout = 10 }):wait()
        if obj.code == 0 then
            local stdout = vim.fn.substitute(obj.stdout, "[\r\n]", "", "g")
            local row, col = unpack(vim.api.nvim_win_get_cursor(0))
            vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { stdout })
            vim.api.nvim_win_set_cursor(0, {row, col + string.len(stdout) })
        end
    end
end

noremap("i", "<A-c>", insert_command)

local toggle_paste = function()
    if vim.opt.signcolumn:get() == "no" then
        vim.opt.number = true
        vim.opt.relativenumber = true
        if vim.bo.filetype == "go" then
            vim.opt.list = true
        end
        vim.opt.signcolumn = "yes"
    else
        vim.opt.number = false
        vim.opt.relativenumber = false
        if vim.bo.filetype == "go" then
            vim.opt.list = false
        end
        vim.opt.signcolumn = "no"
    end
end

noremap("n", "<F2>", toggle_paste)
