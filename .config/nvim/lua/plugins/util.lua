return {
    { -- discover possible vim motions, pretty cool to use sometimes
        "tris203/precognition.nvim",
        event = "BufRead",
        keys = {
            {
                "<leader>Tp",
                function()
                    require("precognition").toggle()
                end,
                desc = "precognition",
            },
        },
    },
    { -- language support
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local config = require "nvim-treesitter.configs"
            config.setup {
                auto_install = true,
                highlight = { enable = true },
                indent = { enable = true },
            }
            vim.treesitter.language.register("markdown", "mdx")
        end,
    },
    { -- wezterm integration, TODO: learn this more
        "willothy/wezterm.nvim",
        config = function()
            local autocmd = vim.api.nvim_create_autocmd
            local wezterm = require "wezterm"
            local cwd = vim.fs.basename(vim.fn.getcwd())

            autocmd("VimEnter", {
                callback = function()
                    local title = string.format(" %s", cwd)
                    wezterm.set_user_var("IS_NVIM", true)
                    wezterm.set_tab_title(title)
                end,
                once = true,
            })

            autocmd("ExitPre", {
                callback = function()
                    local title = string.format(" %s", cwd)
                    wezterm.set_user_var("IS_NVIM", false)
                    wezterm.set_tab_title(title)
                end,
                once = true,
            })
        end,
    },
}
