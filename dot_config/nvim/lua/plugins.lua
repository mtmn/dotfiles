return {
    {
        "bluz71/vim-moonfly-colors",
        version = false,
        priority = 1000,
        config = function()
            vim.cmd [[colorscheme moonfly]]
        end
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true
    },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
            {
                "s",
                mode = {"n", "x", "o"},
                function()
                    require("flash").jump()
                end
            },
            {
                "S",
                mode = {"n", "x", "o"},
                function()
                    require("flash").treesitter()
                end
            },
            {
                "r",
                mode = "o",
                function()
                    require("flash").remote()
                end
            },
            {
                "R",
                mode = {"o", "x"},
                function()
                    require("flash").treesitter_search()
                end
            },
            {
                "<c-s>",
                mode = {"c"},
                function()
                    require("flash").toggle()
                end
            }
        }
    },
    {
        "ibhagwan/fzf-lua",
        config = true
    },
    {
        "stevearc/oil.nvim",
        config = function()
            require("oil").setup()
        end
    },
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim"
        },
        config = true
    },
    {
        "mfussenegger/nvim-jdtls"
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-vsnip"
        },
        config = function()
            local cmp = require("cmp")

            cmp.setup(
                {
                    snippet = {
                        expand = function(args)
                            require("luasnip").lsp_expand(args.body)
                        end
                    },
                    window = {
                        completion = {
                            winhighlight = "Normal:CmpNormal"
                        },
                        documentation = {
                            winhighlight = "Normal:CmpNormal"
                        }
                    },
                    mapping = cmp.mapping.preset.insert(
                        {
                            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                            ["<C-f>"] = cmp.mapping.scroll_docs(4),
                            ["<C-Space>"] = cmp.mapping.complete(),
                            ["<C-e>"] = cmp.mapping.abort(),
                            ["<CR>"] = cmp.mapping.confirm({select = true}) -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                        }
                    ),
                    sources = cmp.config.sources(
                        {
                            {name = "nvim_lsp"},
                            {name = "luasnip"}
                        },
                        {
                            {name = "buffer"}
                        }
                    )
                }
            )
        end
    },
    {
        "rcarriga/nvim-dap-ui",
        event = "VeryLazy",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio"
        },
        opts = {
            controls = {
                element = "repl",
                enabled = false,
                icons = {
                    disconnect = "",
                    pause = "",
                    play = "",
                    run_last = "",
                    step_back = "",
                    step_into = "",
                    step_out = "",
                    step_over = "",
                    terminate = ""
                }
            },
            element_mappings = {},
            expand_lines = true,
            floating = {
                border = "single",
                mappings = {
                    close = {"q", "<Esc>"}
                }
            },
            force_buffers = true,
            icons = {
                collapsed = "",
                current_frame = "",
                expanded = ""
            },
            layouts = {
                {
                    elements = {
                        {
                            id = "scopes",
                            size = 0.50
                        },
                        {
                            id = "stacks",
                            size = 0.30
                        },
                        {
                            id = "watches",
                            size = 0.10
                        },
                        {
                            id = "breakpoints",
                            size = 0.10
                        }
                    },
                    size = 40,
                    position = "left"
                },
                {
                    elements = {
                        "repl",
                        "console"
                    },
                    size = 10,
                    position = "bottom"
                }
            },
            mappings = {
                edit = "e",
                expand = {"<CR>", "<2-LeftMouse>"},
                open = "o",
                remove = "d",
                repl = "r",
                toggle = "t"
            },
            render = {
                indent = 1,
                max_value_lines = 100
            }
        },
        config = function(_, opts)
            local dap = require("dap")
            require("dapui").setup(opts)

            dap.configurations.java = {
                {
                    name = "Debug Launch (2GB)",
                    type = "java",
                    request = "launch",
                    vmArgs = "" .. "-Xmx2g "
                },
                {
                    name = "Debug Attach (8000)",
                    type = "java",
                    request = "attach",
                    hostName = "127.0.0.1",
                    port = 8000
                },
                {
                    name = "Debug Attach (5005)",
                    type = "java",
                    request = "attach",
                    hostName = "127.0.0.1",
                    port = 5005
                },
                {
                    name = "My Custom Java Run Configuration",
                    type = "java",
                    request = "launch",
                    mainClass = "replace.with.your.fully.qualified.MainClass",
                    vmArgs = "" .. "-Xmx2g "
                }
            }
        end
    },
    {
        "neovim/nvim-lspconfig",
        event = "VeryLazy",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim"
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup(
                {
                    ensure_installed = {
                        "jdtls",
                        "lemminx",
                        "marksman",
                        "yamlls",
                        "dockerls",
                        "bashls",
                    }
                }
            )
            require("mason-tool-installer").setup(
                {
                    ensure_installed = {
                        "java-debug-adapter",
                        "java-test"
                    }
                }
            )

            vim.api.nvim_command("MasonToolsInstall")
            local lspconfig = require("lspconfig")
            local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

            require("mason-lspconfig").setup_handlers(
                {
                    function(server_name)
                        if server_name ~= "jdtls" then
                            lspconfig[server_name].setup(
                                {
                                    on_attach = lsp_attach,
                                    capabilities = lsp_capabilities
                                }
                            )
                        end
                    end
                }
            )

            local open_floating_preview = vim.lsp.util.open_floating_preview
            function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
                opts = opts or {}
                opts.border = opts.border or "rounded"
                return open_floating_preview(contents, syntax, opts, ...)
            end
        end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")

            configs.setup(
                {
                    ensure_installed = {
                        "bash",
                        "go",
                        "java",
                        "json",
                        "lua",
                        "nix",
                        "markdown",
			"python",
                        "xml",
                        "yaml",
                    },
                    sync_install = false,
                    highlight = {enable = true},
                    indent = {enable = true}
                }
            )
        end
    },
    {
        "L3MON4D3/LuaSnip",
        dependencies = {
            "saadparwaiz1/cmp_luasnip"
        }
    },
    {
        "tpope/vim-commentary",
        "tpope/vim-repeat",
        "tpope/vim-surround"
    },
    {
        "troydm/zoomwintab.vim"
    }
}
