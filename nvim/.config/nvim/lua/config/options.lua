-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt
opt.iskeyword:append("-") -- consider string-string as whole word

-- Ruby overrides
-- vim.g.lazyvim_ruby_lsp = "solargraph"
-- vim.g.lazyvim_ruby_formatter = "rubocop"
vim.g.lazyvim_picker = "snacks"

-- dbs
vim.g.dbs = {
  {
    name = "prod_master",
    url = function()
      local user = os.getenv("PROD_MASTER_PG_USER")
      local token = vim.fn.system("gcloud sql generate-login-token"):gsub("%s+", "")
      local host = os.getenv("PROD_MASTER_PG_HOST")
      local dbname = os.getenv("PROD_MASTER_PG_DBNAME")

      return string.format("postgresql://%s:%s@%s:5432/%s", user, token, host, dbname)
    end,
  },
}
