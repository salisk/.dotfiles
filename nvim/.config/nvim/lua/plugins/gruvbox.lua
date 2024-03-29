return {
  -- add gruvbox
  {
    "ellisonleao/gruvbox.nvim",
    opts = {
      overrides = {
        ["@namespace"] = { link = "GruvboxAqua" },
      },
    },
  },
  -- { "gruvbox-community/gruvbox" },
  -- { "luisiacc/gruvbox-baby" },
  -- { "morhetz/gruvbox" },
  -- { "sainnhe/gruvbox-material"},
  -- { "marko-cerovac/material.nvim" },
  -- { "catppuccin/nvim", name = "catppuccin" },
  --
  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },
}
