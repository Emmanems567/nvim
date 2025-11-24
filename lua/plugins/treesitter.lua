return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local configs = require("nvim-treesitter.configs")
    configs.setup({
      ensure_installed = { 
        "c", "lua", "vim", "vimdoc", "query",
        "java",
        "cpp",
        "javascript",
        "c_sharp",
        "markdown",
        "markdown_inline",
        "json",
        "bash",
      },
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = true },
      rainbow = { enable = true },
    })
  end,
}
