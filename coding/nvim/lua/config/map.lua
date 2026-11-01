local map = vim.keymap.set

-- useful map
map("n", "H", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "L", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- lsp map
map("n", "<leader>r", vim.lsp.buf.rename, { desc = "Lsp rename", silent = true })
map("n", "<leader>a", vim.lsp.buf.code_action, { desc = "Lsp action", silent = true })
map("n", "gd", vim.lsp.buf.definition, { desc = "Lsp def", silent = true })
map("n", "gi", vim.lsp.buf.implementation, { desc = "Lsp impl", silent = true })
map("n", "J", vim.diagnostic.open_float, { desc = "Open diagnostic", silent = true })

-- useful map
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "move down", silent = true })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "move up", silent = true })

map("v", "<c-c>", '"+y', { desc = "Copy to clipboard", silent = true })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- visual normal
map("v", ".", ":norm.<cr>", { desc = "Visual normal" })
