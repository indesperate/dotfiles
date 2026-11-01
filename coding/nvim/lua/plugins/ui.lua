return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        init = function()
            require("local_plugins.yazi").setup()
        end,
        keys = {
            {
                "<leader>n",
                function()
                    require("local_plugins.yazi").toggle()
                end,
                desc = "Open Yazi",
            },
        },
        opts = {
            bigfile = { enabled = true },
            indent = {
                enabled = true,
                indent = { enabled = true, char = "▏", hl = "Whitespace" },
                scope = {
                    enabled = true,
                    char = "▏",
                    only_current = true,
                    hl = { "rainbow1", "rainbow2", "rainbow3", "rainbow4", "rainbow5", "rainbow6" },
                },
                animate = { enabled = false },
            },
            input = {
                enabled = true,
                win = {
                    row = function()
                        return math.floor((vim.o.lines - 3) / 2)
                    end,
                },
            },
            picker = { enabled = true },
            quickfile = { enabled = true },
        },
        config = function(_, opts)
            require("snacks").setup(opts)
            vim.api.nvim_create_user_command("Scratch", function()
                Snacks.scratch()
            end, { desc = "Toggle scratchpad", force = false })
            vim.api.nvim_create_user_command("ScratchSelect", function()
                Snacks.scratch.select()
            end, { desc = "Select scratchpad", force = false })
            vim.api.nvim_create_user_command("Bd", function(args)
                Snacks.bufdelete({ force = args.bang })
            end, { desc = "Delete buffer (keep layout)", bang = true, force = false })
            vim.api.nvim_create_user_command("Bda", function(args)
                Snacks.bufdelete.all({ force = args.bang })
            end, { desc = "Delete all buffers (keep layout)", bang = true, force = false })
            vim.api.nvim_create_user_command("Bdo", function(args)
                Snacks.bufdelete.other({ force = args.bang })
            end, { desc = "Delete other buffers (keep layout)", bang = true, force = false })
        end,
    },
    -- under status line
    {
        "nvim-lualine/lualine.nvim",
        opts = {
            options = {
                theme = "catppuccin-nvim",
                globalstatus = true,
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "diff", "diagnostics" },
                lualine_c = { "filename", "%S" },
                lualine_x = { "selectioncount", "searchcount", "lsp_status", "filetype" },
                lualine_y = { "progress" },
                lualine_z = { "branch" },
            },
        },
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
}
