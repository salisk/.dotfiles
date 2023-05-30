return {
  -- add gruvbox
  { "ellisonleao/gruvbox.nvim", priority = 1000 },
  -- { "gruvbox-community/gruvbox" },
  -- { "morhetz/gruvbox" },
  -- { "sainnhe/gruvbox-material"},
  -- { "marko-cerovac/material.nvim" },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },
}
