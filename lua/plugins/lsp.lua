return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- El núcleo de Java (Debe ser dependencia para cargar antes)
            "nvim-java/nvim-java",
            
            -- Gestores de instalación
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            
            -- Autocompletado
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/nvim-cmp",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        },
        config = function()
            -- =========================================================
            -- 1. INICIAR JAVA PRIMERO (REGLA DE ORO)
            -- =========================================================
            -- Esto inyecta la lógica de nvim-java en lspconfig
            require("java").setup()

            -- =========================================================
            -- 2. CONFIGURAR MASON
            -- =========================================================
            require("mason").setup()
            
            -- =========================================================
            -- 3. CONFIGURAR OTROS LENGUAJES (Mason-LSPConfig)
            -- =========================================================
            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            require("mason-lspconfig").setup({
                -- NO pongas jdtls aquí, nvim-java lo gestiona
                ensure_installed = {
                    "lua_ls",
                    "html",
                    "cssls",
                    "clangd",
                    "ts_ls",
                    "omnisharp",
                },
                handlers = {
                    -- Configuración automática para todo lo que NO sea Java
                    function(server_name)
                        lspconfig[server_name].setup({
                            capabilities = capabilities,
                        })
                    end,
                    
                    -- Excepción para Lua (Variable global 'vim')
                    ["lua_ls"] = function()
                        lspconfig.lua_ls.setup({
                            capabilities = capabilities,
                            settings = {
                                Lua = { diagnostics = { globals = { "vim" } } },
                            },
                        })
                    end,
                }
            })

            -- =========================================================
            -- 4. DISPARAR JAVA MANUALMENTE
            -- =========================================================
            -- Como lo quitamos de Mason-LSPConfig para evitar conflictos,
            -- debemos iniciarlo explícitamente aquí. nvim-java ya preparó el terreno.
            lspconfig.jdtls.setup({
                capabilities = capabilities,
                settings = {
                    java = {
                        configuration = {
                            runtimes = {
                                {
                                    name = "JavaSE-25",
                                    path = "/usr/lib/jvm/java-25-openjdk",
                                    default = true,
                                },
                                {
                                    name = "JavaSE-1.8",
                                    path = "/usr/lib/jvm/java-8-openjdk",
                                }
                            }
                        }
                    }
                }
            })

            -- =========================================================
            -- 5. CONFIGURAR AUTOCOMPLETADO (CMP)
            -- =========================================================
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            
            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ['<Tab>'] = cmp.mapping.select_next_item(),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                }, {
                    { name = 'buffer' },
                })
            })
        end,
    }
}
