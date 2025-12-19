return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"nvim-java/nvim-java",

			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",

			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/nvim-cmp",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
		config = function()
			require("java").setup()

			require("mason").setup()

			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"html",
					"cssls",
					"clangd",
					"ts_ls",
					"omnisharp",
				},
				handlers = {
					function(server_name)
						lspconfig[server_name].setup({
							capabilities = capabilities,
						})
					end,

					["lua_ls"] = function()
						lspconfig.lua_ls.setup({
							capabilities = capabilities,
							settings = {
								Lua = { diagnostics = { globals = { "vim" } } },
							},
						})
					end,
				},
			})

      local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1

      local java8_path = ""
      local java_latest_path = ""

      if is_windows then
        java_latest_path = "C:\\Program Files\\Amazon Coretto\\jdk21.0.3_9"
        java8_path = "C:\\ProgramData\\Oracle\\Java\\javapath"
      else
        java_latest_path = "/usr/lib/jvm/java-25-openjdk"
        java8_path = "/usr/lib/jvm/java-8-openjdk"
      end

			lspconfig.jdtls.setup({
				capabilities = capabilities,
				settings = {
					java = {
						configuration = {
							runtimes = {
								{
									name = "JavaSE-25",
									path = java_latest_path,
									default = true,
								},
                {
                  name = "JavaSE-21",
                  path = java_latest_path,
                  default = true,
                },
								{
									name = "JavaSE-1.8",
									path = java8_path,
								},
							},
						},
					},
				},
			})

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
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping.select_next_item(),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
				}),
			})
		end,
	},
}
