return {
    { -- awesome mark manager kinda like harpoon but better imo
        "otavioschwanck/arrow.nvim",
        opts = {
            show_icons = true,
            leader_key = ",", -- Recommended to be a single key
            buffer_leader_key = "m", -- Per Buffer Mappings
        },
    },
    { -- surround stuff with cool comment boxes, title author description etc
        "LudoPinelli/comment-box.nvim",
        keys = {
            {
                "<leader>cb",
                "<cmd>CBccbox18<cr>",
                desc = "comment - title box",
            },
            {
                "<leader>ct",
                "<cmd>CBllline6<cr>",
                desc = "comment - title line",
            },
        },
    },
    { -- cool jumplist stuff, TODO: check it out
        "folke/flash.nvim",
        event = "VeryLazy",
        vscode = true,
        opts = {},
        -- stylua: ignore start
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
            { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
            { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
            { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
        },
        -- stylua: ignore end
    },
    { -- better find and replace
        "MagicDuck/grug-far.nvim",
        opts = { headerMaxWidth = 80 },
        cmd = "GrugFar",
        keys = {
            {
                "<leader>sr",
                function()
                    local grug = require "grug-far"
                    local ext = vim.bo.buftype == "" and vim.fn.expand "%:e"
                    grug.open {
                        transient = true,
                        prefills = {
                            filesFilter = ext and ext ~= "" and "*." .. ext or nil,
                        },
                    }
                end,
                mode = { "n", "v" },
                desc = "search and replace",
            },
        },
    },
    { -- highlight color codes
        "brenoprata10/nvim-highlight-colors",
        config = function()
            require("nvim-highlight-colors").setup {
                render = "virtual",
                virtual_symbol = "",
                enable_tailwind = true,
                enable_named_colors = false,
                exclude_filetypes = { "lazy" },
            }
        end,
    },
    { -- highlight TODOs and such
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
        event = "BufRead",
        keys = {
            { "<leader>fc", "<cmd>TodoTelescope<cr>", desc = "todo comments" },
        },
    },
    { -- popup terminal
        "akinsho/toggleterm.nvim",
        version = "*",
        event = "ColorScheme",
        cmd = "ToggleTerm",
        config = function()
            --local highlights = require "rose-pine.plugins.toggleterm"
            require("toggleterm").setup {
                --highlights = highlights,
                direction = "float",
                shade_terminals = false,
                float_opts = {
                    width = function()
                        return math.ceil(vim.o.columns * 0.5)
                    end,
                    height = function()
                        return math.ceil(vim.o.lines * 0.5)
                    end,
                    winblend = 0,
                },
            }
        end,
        keys = function(_, keys)
            local function toggleterm()
                local venv = vim.b["virtual_env"]
                local term = require("toggleterm.terminal").Terminal:new {
                    env = venv and { VIRTUAL_ENV = venv } or nil,
                    count = vim.v.count > 0 and vim.v.count or 1,
                }
                term:toggle()
            end
            local mappings = {
                { "<leader><leader>", mode = { "n", "t" }, toggleterm, desc = "toggle terminal" },
            }
            return vim.list_extend(mappings, keys)
        end,
    },
    { -- small window for LSP diag, references, telescope results, etc
        "folke/trouble.nvim",
        opts = {
            modes = {
                preview_float = {
                    mode = "diagnostics",
                    preview = {
                        type = "float",
                        relative = "editor",
                        border = "rounded",
                        title = "Preview",
                        title_pos = "center",
                        position = { 0, -2 },
                        size = { width = 0.3, height = 0.3 },
                        zindex = 200,
                    },
                },
            },
        },
        -- stylua: ignore start
        keys = {
            {"<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "diagnostics",},
            {"<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "buffer Diagnostics",},
            {"<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "symbols",},
            {"<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "lsp definitions / references / ...",},
            {"<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "location list",},
            {"<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "quickfix list",},
        },
        -- stylua: ignore end
    },
    { -- key map discoverability
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {
            preset = "modern",
            win = { border = "single" },
            spec = {
                -- groups
                { "<leader>a", group = "ai", icon = { icon = "", color = "orange" } },
                { "<leader>b", group = "buffer" },
                { "<leader>c", group = "code" },
                { "<leader>d", group = "debug" },
                { "<leader>f", group = "find" },
                { "<leader>g", group = "git" },
                { "<leader>h", group = "hurl", icon = "" },
                { "<leader>l", group = "lsp" },
                { "<leader>n", group = ".net", icon = "󰌛" },
                { "<leader>p", group = "packages", icon = "" },
                { "<leader>pn", group = "dotnet", icon = "󰌛" },
                { "<leader>r", group = "compiler", icon = "" },
                { "<leader>t", group = "test" },
                { "<leader>T", group = "toggle" },
                { "<leader>x", group = "diagnostics" },
                -- commands
                { "<leader>aa", icon = { icon = "", color = "red" } },
                { "<leader>aq", icon = "󱧌" },
                { "<leader>bd", icon = "󰭿" },
                { "<leader>bD", icon = "󰭿" },
                { "<leader>ca", icon = "󱐋" },
                { "<leader>cb", icon = "󰅺" },
                { "<leader>cf", icon = "" },
                { "<leader>cm", icon = "󱓡", desc = "join/split block" },
                { "<leader>cr", icon = "󰏪" },
                { "<leader>ct", icon = "󰅺" },
                { "<leader>db", icon = "󰃤" },
                { "<leader>e", icon = "󰙅" },
                { "<leader>/", icon = "󰅺" },
            },
            disable = {
                ft = {
                    "lazygit",
                    "toggleterm",
                },
            },
        },
    },
    { -- dim inactive portions of code while editing, TODO: look into how to activate
        "folke/twilight.nvim",
        event = "BufReadPre",
        opts = {
            dimming = {
                alpha = 0.40,
            },
        },
    },
    { -- center floating pane by default, integrates some cool stuff w wezterm
        "folke/zen-mode.nvim",
        event = "BufReadPre",
        opts = {
            wezterm = {
                enabled = true,
                font_size = "+4",
            },
        },
        keys = {
            { "<Leader>z", "<cmd>ZenMode<cr>", desc = "zen mode" },
        },
    },
}
