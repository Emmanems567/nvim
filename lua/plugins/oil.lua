return {
	"stevearc/oil.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("oil").setup({
			default_file_explorer = true,
			columns = {},
			keymaps = {
				["q"] = "actions.close",
			},
			view_options = {
				show_hidden = true,
			},
			skip_confirm_for_simple_edits = true,
		})
		vim.keymap.set("n", "<leader>-", require("oil").toggle_float, { desc = "Toggle float oil" })
	end,
}
