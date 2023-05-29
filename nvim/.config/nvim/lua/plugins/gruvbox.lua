return {
  -- add gruvbox
  { "ellisonleao/gruvbox.nvim" },
  -- { "gruvbox-community/gruvbox" },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },
}
