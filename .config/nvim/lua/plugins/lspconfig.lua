local servers = {
    "jsonls",
    "lua_ls",
    "marksman",
    "yamlls",
}

-- TODO: figure out how this works and how to hook in python

return { -- prebuilt lspconfigs, autoinstall
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        for _, lsp in ipairs(servers) do
            vim.lsp.config[lsp] = {
                on_attach = on_attach,
                capabilities = capabilities,
                -- add other settings here
            }
        end

        vim.lsp.config.vtsls = {
            on_attach = on_attach,
            capabilities = capabilities,
            root_dir = util.root_pattern "package.json",
        }

        vim.lsp.config.denols = {
            on_attach = on_attach,
            capabilities = capabilities,
            root_dir = util.root_pattern "deno.json",
        }

        vim.lsp.config.powershell_es = {
            on_attach = on_attach,
            capabilities = capabilities,
            bundle_path = vim.fn.stdpath "data" .. "/mason/packages/powershell-editor-services",
            init_options = {
                enableProfileLoading = false,
            },
        }

        vim.lsp.config.ruff = {
            init_options = {
                settings = {
                    enable = true,
                    lineLength = 120,
                    showSyntaxErrors = true,
                    lint = {
                        enable = true,
                        run = "onType",
                        select = {
                            "E",    -- pycodestyle errors
                            "W",    -- pycodestyle warnings
                            "F",    -- pyflakes
                            "N",    -- PEP8 naming
                            "B",    -- flake8 bugbear
                            "A",    -- flake8 shawdowing builtins
                            "PL",   -- pylint
                            "COM",  -- flake8 commas
                            "DTZ",  -- flake8 datetime stuff
                            "EM",   -- flake8 error messages
                            "FIX",  -- FIXMEs, TODOs, etc
                            "ICN",  -- flake8 import conventions
                            "LOG",  -- flake8 logging
                            "G",    -- flake8 logging format
                            "INP",  -- flake8 implicit namespace
                            "PIE",  -- flake8 misc
                            "T20",  -- flake8 discourage print statements
                            "Q",    -- flake8 quotes
                            "RSE",  -- flake8 raise
                            "SLF",  -- flake8 self
                            "SIM",  -- flake8 simplifiy
                            "TID",  -- flake8 tidy imports
                            "TD",   -- flake8 TODOs
                            "ARG",  -- flake8 arguments
                            "FLY",  -- flynt
                            "C90",  -- check for high "McCabe Complexity"
                            "ERA",  -- commented out code
                            "S",    -- flake8 bandit
                            --"RET",  -- flake8 return
                            --"D",    -- pydocstyle
                        },
                        ignore = {},
                    },
                }
            }
        }

        vim.lsp.config.pyright = {
            settings = {
                python = {
                    analysis = {
                        autoSearchPaths = true,
                        diagnosticMode = "openFilesOnly",
                        useLibraryCodeForTypes = true,
                    }
                }
            }
        }

    end,
    keys = {
        -- stylua: ignore start
        { "gD", function() vim.lsp.buf.declaration()end, desc = "lsp declaration" },
        { "gd", function() vim.lsp.buf.definition()end, desc = "lsp definition" },
        { "K", function() vim.lsp.buf.hover()end, desc = "lsp hover" },
        { "gi", function() vim.lsp.buf.implementation()end, desc = "lsp implementation" },
        { "gK", function() vim.lsp.buf.signature_help()end, desc = "lsp signature help" },
        { "gy", function() vim.lsp.buf.type_definition()end, desc = "lsp type definition" },
        { "gr", function() vim.lsp.buf.references()end, desc = "lsp references" },
        { "[d", function() vim.lsp.diagnostic.goto_prev()end, desc = "lsp goto prev diagnostic" },
        { "]d", function() vim.lsp.diagnostic.goto_next()end, desc = "lsp goto next diagnostic" },
        {"<leader>Ti", function() vim.lsp.inlay_hint.enable() end, desc = "inlay hint"},
        -- stylua: ignore start
    },
}
