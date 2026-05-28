return {
  {
    "folke/sidekick.nvim",
    opts = {
      cli = {
        tools = {
          kimchi = {
            cmd = { "kimchi" },
            is_proc = "\\<kimchi\\>",
            url = "https://github.com/getkimchi/kimchi",
            resume = { "--resume" },
            continue = { "--continue" },
          },
        },
      },
    },
  },
}
