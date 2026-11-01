return {
    "saghen/blink.cmp",
    dependencies = {
        "saghen/blink.lib",
        "rafamadriz/friendly-snippets",
    },
    build = function()
        require("blink.cmp").build():pwait()
    end,

    opts = {
        keymap = {
            preset = "super-tab",
            ["<C-j>"] = { "show", "show_documentation", "hide_documentation" },
        },

        appearance = {
            nerd_font_variant = "normal",
        },

        signature = { enabled = true },

        completion = {
            documentation = { auto_show = false },
            ghost_text = { enabled = false },
        },

        sources = {
            default = { "lsp", "path", "snippets", "buffer" },
        },

        fuzzy = { implementation = "rust" },
    },
}
