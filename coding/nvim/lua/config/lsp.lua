-- diagnostic
vim.diagnostic.config({ virtual_text = true })

-- lsp config
vim.lsp.enable({
    "bashls",
    "lua_ls",
    "neocmake",
    "clangd",
    "rust_analyzer",
    "tsc",
    "tombi",
    "ty",
    "ruff",
    "nushell",
    "hls",
})
vim.lsp.codelens.enable()
vim.lsp.inlay_hint.enable()
