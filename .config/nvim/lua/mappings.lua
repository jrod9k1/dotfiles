local map = vim.keymap

-- buffers
map.set("n", "<leader>bn", "<cmd> enew <cr>", { desc = "new buffer" })
map.set("n", "<leader>bd", "<cmd> bd <cr>", { desc = "delete current buffer" })
map.set("n", "<leader>bD", "<cmd> %bd|e#|bd#|'\" <cr>", { desc = "delete all buffers except current one" })


