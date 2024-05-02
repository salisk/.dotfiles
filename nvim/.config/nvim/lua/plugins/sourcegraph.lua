return {
  "sourcegraph/sg.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
  config = function()
    require("sg").setup({
      default_mappings = true,
      debug = false,
      -- The default is to use the telescope.nvim extension if it is installed.
      -- If you want to use a different extension, specify the path to it here.
      -- extensions = { "fzf" },
    })
  end,
}
