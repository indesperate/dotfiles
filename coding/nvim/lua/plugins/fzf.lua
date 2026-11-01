return {
    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            file_icon_padding = " ",
        },
        cmd = "FzfLua",
        keys = {
            {
                "<leader>fr",
                function()
                    require("fzf-lua").lsp_references()
                end,
                desc = "Search lsp references",
            },
            {
                "<leader>fc",
                function()
                    require("fzf-lua").git_status()
                end,
                desc = "Search git status",
            },
            {
                "<leader>fd",
                function()
                    require("fzf-lua").diagnostics_document()
                end,
                desc = "Search buffer diagnostics",
            },
            {
                "<leader>fs",
                function()
                    require("fzf-lua").lsp_document_symbols()
                end,
                desc = "Search buffer symbols",
            },
        },
    },
}
