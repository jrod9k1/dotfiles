return { -- dark high contrast theme
    "iagorrr/noctishc.nvim",
    lazy = false,
    config = function()
        vim.cmd.colorscheme("noctishc")
    end,
}
