return {
    "stevearc/conform.nvim",
    lazy = true,
    cmd = "ConformInfo",
    opts = {
        formatters_by_ft = {
            lua = { "stylua" },
            c = { "clang-format" },
            cpp = { "clang-format" },
            sh = { "shfmt" },
            json = { "biome" },
            jsonc = { "biome" },
            javascript = { "biome" },
            javascriptreact = { "biome" },
            typescript = { "biome" },
            typescriptreact = { "biome" },
        },
        default_format_opts = {
            lsp_format = "fallback",
        },
    },
    keys = {
        {
            "<leader>=",
            function()
                require("conform").format()
            end,
            desc = "format",
        },
    },
}
