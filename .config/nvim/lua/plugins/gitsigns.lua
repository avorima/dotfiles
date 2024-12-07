return {
    {
        "lewis6991/gitsigns.nvim",
        opts = {
          current_line_blame_opts = {
            delay = 250,
            ignore_whitespace = true
          },

          preview_config = {
            -- Options passed to nvim_open_win
            border = "shadow",
            style = "minimal",
            relative = "cursor",
            row = 0,
            col = 1
          },

          signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
          numhl      = true,  -- Toggle with `:Gitsigns toggle_numhl`

          _on_attach_pre = function(bufnr, callback)
            local file = vim.api.nvim_buf_get_name(bufnr)
            local dir = vim.fs.dirname(file)
            local home = os.getenv("HOME")
            if not home or not vim.startswith(dir, home) then
              return
            end
            local cmd = {
              "yadm",
              "ls-files"
            }
            local opts = {}
            opts.text = true
            local stdout = ""
            vim.system(cmd, opts, function(obj)
              stdout = obj.stdout
            end)

            local cb_opts = {}
            if stdout:find(file) then
              cb_opts.gitdir = vim.fs.joinpath(os.getenv("XDG_DATA_HOME"), "yadm", "repo.git")
              cb_opts.toplevel = home
            end

            callback(cb_opts)
          end,

          on_attach = function(bufnr)
            local gs = package.loaded.gitsigns

            local function map(mode, l, r, opts)
              opts = opts or {}
              opts.buffer = bufnr
              vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation
            map("n", "]c", function()
              if vim.wo.diff then return "]c" end
              vim.schedule(function() gs.next_hunk() end)
              return "<Ignore>"
            end, {expr=true})

            map("n", "[c", function()
              if vim.wo.diff then return "[c" end
              vim.schedule(function() gs.prev_hunk() end)
              return "<Ignore>"
            end, {expr=true})

            -- Actions
            map({"n", "v"}, "<leader>hs", ":Gitsigns stage_hunk<CR>")
            map({"n", "v"}, "<leader>hr", ":Gitsigns reset_hunk<CR>")
            map("n", "<leader>hS", gs.stage_buffer)
            map("n", "<leader>hu", gs.undo_stage_hunk)
            map("n", "<leader>hR", gs.reset_buffer)
            map("n", "<leader>hp", gs.preview_hunk)
            map("n", "<leader>hb", function() gs.blame_line{full=true} end)
            map("n", "<leader>tb", gs.toggle_current_line_blame)
            map("n", "<leader>hd", gs.diffthis)
            map("n", "<leader>hD", function() gs.diffthis("~") end)
            map("n", "<leader>td", gs.toggle_deleted)
            map("n", "<leader>tl", gs.toggle_linehl)
            map("n", "<leader>tw", gs.toggle_word_diff)

            -- Text object
            map({"o", "x"}, "ih", ":<C-U>Gitsigns select_hunk<CR>")
          end
        },
    },
}
