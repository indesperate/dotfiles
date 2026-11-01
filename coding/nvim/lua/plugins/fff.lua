return
-- Package name changed from `fff.nvim` to `fff`. If you installed fff.nvim before, clean with `:Lazy clean`
{
    "dmtrKovalenko/fff",
    build = function()
        -- downloads a prebuilt binary or falls back to cargo build
        require("fff.download").download_or_build_binary()
    end,
    opts = {},
    lazy = false, -- the plugin lazy-initialises itself
    keys = {
        {
            "<leader>ff",
            function()
                require("fff").find_files()
            end,
            desc = "FFFind files",
        },
        {
            "<leader>fg",
            function()
                require("fff").live_grep()
            end,
            desc = "LiFFFe grep",
        },
        {
            "<leader>fw",
            function()
                require("fff").live_grep_under_cursor()
            end,
            mode = { "n", "x" },
            desc = "Search current word / selection",
        },
    },
}
