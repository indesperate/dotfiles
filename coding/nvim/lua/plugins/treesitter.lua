return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        branch = "main",
        config = function()
            local treesitter = require("nvim-treesitter")
            treesitter.setup({})
            local should_install = {
                "bash",
                "c",
                "cpp",
                "cmake",
                "csv",
                "javascript",
                "just",
                "json",
                "lua",
                "markdown",
                "markdown_inline",
                "make",
                "nu",
                "python",
                "rust",
                "toml",
                "tsx",
                "typescript",
                "vim",
                "vimdoc",
                "yaml",
                "zig",
            }

            treesitter.install(should_install)

            vim.api.nvim_create_autocmd("FileType", {
                callback = function(args)
                    if vim.list_contains(treesitter.get_installed(), vim.treesitter.language.get_lang(args.match)) then
                        vim.treesitter.start(args.buf)
                    end
                end,
            })
        end,
    },
}
