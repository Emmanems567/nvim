return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "jay-babu/mason-null-ls.nvim",
  },
  config = function()
    local null_ls = require("null-ls")
    local mason_null_ls = require("mason-null-ls")

    mason_null_ls.setup({
      ensure_installed = {
        "prettier",
        "stylua",
        "google_java_format",
      },
      automatic_installation = true,
    })

    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.formatting.google_java_format,
      },
    })
    vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { desc = "Code formatting" })
  end,
}
