local autocmd = vim.api.nvim_create_autocmd

-- close some filetypes with <q>
autocmd("FileType", {
    pattern = {
        "help",
        "man",
        "checkhealth",
        "qf",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>quit<cr>", { buffer = event.buf, silent = true })
    end,
})
