return {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    opts = {
        on_attach = function(buffer)
            local gs = package.loaded.gitsigns

            local function map(mode, l, r, desc)
                vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc, silent = true })
            end

            local function obtain()
                if vim.wo.diff then
                    vim.cmd.normal({ "do", bang = true })
                else
                    gs.stage_hunk()
                end
            end
            local function put()
                if vim.wo.diff then
                    vim.cmd.normal({ "dp", bang = true })
                else
                    gs.reset_hunk()
                end
            end
            local function next_change()
                if vim.wo.diff then
                    vim.cmd.normal({ "]c", bang = true })
                else
                    gs.nav_hunk("next")
                end
            end
            local function prev_change()
                if vim.wo.diff then
                    vim.cmd.normal({ "[c", bang = true })
                else
                    gs.nav_hunk("prev")
                end
            end
            map("n", "]c", next_change, "Next Change")
            map("n", "[c", prev_change, "Prev Change")
            map("n", "do", obtain, "Obtain Diff")
            map("n", "dp", put, "Put Diff")
            map("n", "dO", gs.preview_hunk_inline, "Preview Hunk Inline")
            map("n", "db", gs.diffthis, "Diff This")
            map({ "o", "x" }, "ic", gs.select_hunk, "GitSigns Select Hunk")
        end,
    },
}
