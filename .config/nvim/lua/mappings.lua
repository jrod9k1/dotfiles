local map = vim.keymap


-- clipboard keys
vim.api.nvim_set_keymap('n', '<leader>y', '"+y', { noremap = true, silent = true, desc = "copy to clipboard" })
vim.api.nvim_set_keymap('n', '<leader>p', '"+p', { noremap = true, silent = true, desc = "paste from clipboard" })

-- buffers
map.set("n", "<leader>bn", "<cmd> enew <cr>", { desc = "new buffer" })
map.set("n", "<leader>bd", "<cmd> bd <cr>", { desc = "delete current buffer" })
map.set("n", "<leader>bD", "<cmd> %bd|e#|bd#|'\" <cr>", { desc = "delete all buffers except current one" })


