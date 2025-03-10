return {
    { -- markdown preview, like it says on the can
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
        keys = {
            {
                "<leader>cp",
                ft = "markdown",
                "<cmd>MarkdownPreviewToggle<cr>",
                desc = "Markdown Preview",
            },
        },
        config = function()
            vim.cmd [[do FileType]]
        end,
    },
    { -- another MD previewer?
        "OXY2DEV/markview.nvim",
        ft = { "markdown", "codecompanion" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "echasnovski/mini.icons",
        },
        opts = function()
            local palette = require "noctishc.palette"
            local opts = {
                code_blocks = {
                    hl = "CursorLine",
                    sign_hl = nil,
                },
                filetypes = { "markdown", "quarto", "rmd", "codecompanion" },
                highlight_groups = {
                    { group_name = "Heading1", value = { fg = palette.fg, bg = palette.red } },
                    { group_name = "Heading1Corner", value = { fg = palette.red } },
                    { group_name = "Heading1Sign", value = { fg = palette.red } },
                    { group_name = "Heading2", value = { fg = palette.fg, bg = palette.blue } },
                    { group_name = "Heading2Corner", value = { fg = palette.blue } },
                    { group_name = "Heading2Sign", value = { fg = palette.blue } },
                    { group_name = "Heading3", value = { fg = palette.fg, bg = palette.yellow } },
                    { group_name = "Heading3Corner", value = { fg = palette.yellow } },
                    { group_name = "Heading3Sign", value = { fg = palette.yellow } },
                    { group_name = "Heading4", value = { fg = palette.fg, bg = palette.orange } },
                    { group_name = "Heading4Corner", value = { fg = palette.orange } },
                    { group_name = "Heading4Sign", value = { fg = palette.orange } },
                    { group_name = "Heading5", value = { fg = palette.fg, bg = palette.blue } },
                    { group_name = "Heading5Corner", value = { fg = palette.blue } },
                    { group_name = "Heading5Sign", value = { fg = palette.blue } },
                    { group_name = "Heading6", value = { fg = palette.fg, bg = palette.green } },
                    { group_name = "Heading6Corner", value = { fg = palette.green } },
                    { group_name = "Heading6Sign", value = { fg = palette.green } },
                },
                headings = require("markview.presets").headings.decorated_labels,
                html = {
                    enabled = true,
                },
                inline_codes = {
                    hl = "CursorLine",
                },
                list_items = {
                    marker_plus = {
                        text = "⯁",
                    },
                    marker_minus = {
                        text = "",
                    },
                    marker_star = {
                        text = "⬣",
                    },
                },
                tables = {
                -- stylua: ignore start
                text = {
                    "┌", "─", "┐", "┬",
                    "├", "│", "┤", "┼",
                    "└", "─", "┘", "┴",
                    "╼", "╾", "╴", "╶"
                },
                    -- stylua: ignore end
                },
            }
            vim.cmd "Markview enableAll"
            return opts
        end,
    },
}
