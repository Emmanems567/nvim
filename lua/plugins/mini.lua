return {
  --Mini nvim
  { "echasnovski/mini.nvim", version = false },
 
  --Mini file explorer
  {
    'echasnovski/mini.files',
    config = function()
      local MiniFiles = require("mini.files")
      MiniFiles.setup({
        mappings = {
          go_in = "<CR>",
          go_out_plus = "-",
        },
      })
      vim.keymap.set('n', '<leader>e', '<cmd>lua MiniFiles.open()<CR>', { desc = "Toggle mini file expolorer" })
      vim.keymap.set('n', '<leader>ef', function()
        MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
        MiniFiles.reveal_cwd()
      end, { desc = "Toggle into current opened file" })
    end
  }
}
