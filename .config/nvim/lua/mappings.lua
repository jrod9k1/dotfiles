local map = vim.keymap


-- clipboard keys
map.set({"n", "v"}, "<leader>y", '"+y', { noremap = true, silent = true, desc = "copy to clipboard" })
map.set({"n", "v"}, "<leader>p", '"+p', { noremap = true, silent = true, desc = "paste from clipboard" })

-- buffers
map.set("n", "<leader>bn", "<cmd> enew <cr>", { desc = "new buffer" })
map.set("n", "<leader>bd", "<cmd> bd <cr>", { desc = "delete current buffer" })
map.set("n", "<leader>bD", "<cmd> %bd|e#|bd#|'\" <cr>", { desc = "delete all buffers except current one" })

-- quick pane moves
map.set("n", "<C-A-Left>", "<C-w>h", { noremap = true, silent = true, desc = "move left" })
map.set("n", "<C-A-Down>", "<C-w>j", { noremap = true, silent = true, desc = "move down" })
map.set("n", "<C-A-Up>", "<C-w>k", { noremap = true, silent = true, desc = "move up" })
map.set("n", "<C-A-Right>", "<C-w>l", { noremap = true, silent = true, desc = "move right" })

-- quick splits
map.set("n", "<C-w>%", ":vsplit<CR>", { noremap = true, silent = true, desc = "split vertical" })
map.set("n", '<C-w>"', ":split<CR>", { noremap = true, silent = true, desc = "split horizontal" })

-- resize splits?
map.set("n", "<M-,>", "<c-w>5<")
map.set("n", "<M-.>", "<c-w>5>")
map.set("n", "<M-t>", "<C-W>+")
map.set("n", "<M-s>", "<C-W>-")

-- allow moving the cursor through wrapped lines with j, k, up, down
map.set(
    { "n", "v" },
    "j",
    'v:count || mode(1)[0:1] == "no" ? "j" : "gj"',
    { expr = true, desc = "move down through wrapped lines" }
)

map.set(
    { "n", "v" },
    "k",
    'v:count || mode(1)[0:1] == "no" ? "k" : "gk"',
    { expr = true, desc = "move down through wrapped lines" }
)

map.set(
    { "n", "v" },
    "<up>",
    'v:count || mode(1)[0:1] == "no" ? "k" : "gk"',
    { expr = true, desc = "move down through wrapped lines" }
)

map.set(
    { "n", "v" },
    "<down>",
    'v:count || mode(1)[0:1] == "no" ? "j" : "gj"',
    { expr = true, desc = "move down through wrapped lines" }
)
