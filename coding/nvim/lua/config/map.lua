local map = vim.keymap.set

-- useful map
map("n", "H", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "L", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "gb", "<cmd>BufferLinePick<cr>", { desc = "Pick buffer", silent = true })

-- lsp map
map("n", "<leader>r", vim.lsp.buf.rename, { desc = "Lsp rename", silent = true })
map("n", "<leader>a", vim.lsp.buf.code_action, { desc = "Lsp action", silent = true })
map("n", "gd", vim.lsp.buf.definition, { desc = "Lsp def", silent = true })
map("n", "gi", vim.lsp.buf.implementation, { desc = "Lsp impl", silent = true })
map("n", "J", vim.diagnostic.open_float, { desc = "Open diagnostic", silent = true })

map("x", "J", ":m '>+1<cr>gv=gv", { desc = "move down", silent = true })
map("x", "K", ":m '<-2<cr>gv=gv", { desc = "move up", silent = true })

map("x", "<c-c>", '"+y', { desc = "Copy to clipboard", silent = true })

-- better indenting
map("x", "<", "<gv")
map("x", ">", ">gv")

-- visual normal
map("x", ".", ":norm.<cr>", { desc = "Visual normal" })
