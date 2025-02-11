return {
  -- add gruvbox
  {
    "ellisonleao/gruvbox.nvim",
    opts = {
      overrides = {
        SnacksPickerDir = { link = "Comment" },
        ["@namespace"] = { link = "GruvboxAqua" },
      },
    },
  },
  -- { "gruvbox-community/gruvbox" },
  -- { "luisiacc/gruvbox-baby" },
  -- { "morhetz/gruvbox" },
  { "sainnhe/gruvbox-material" },
  -- { "marko-cerovac/material.nvim" },
  -- { "catppuccin/nvim", name = "catppuccin" },
  { "rebelot/kanagawa.nvim" },
  --
  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
      -- colorscheme = "kanagawa-dragon",
    },
  },
}
