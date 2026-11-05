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
    },
    {
        "akinsho/bufferline.nvim",
        version = "*",
        lazy = false,
        dependencies = { "catppuccin", "nvim-tree/nvim-web-devicons" },
        opts = function()
            return {
                highlights = require("catppuccin.special.bufferline").get_theme(),
                options = {
                    mode = "buffers",
                    diagnostics = "nvim_lsp",
                },
            }
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
                lualine_c = { "%S" },
                lualine_x = { "selectioncount", "searchcount", "lsp_status", "filetype" },
                lualine_y = { "progress" },
                lualine_z = { "branch" },
            },
        },
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
}
