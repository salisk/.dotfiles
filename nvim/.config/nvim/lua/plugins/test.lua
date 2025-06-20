return {
  "nvim-neotest/neotest",
  optional = true,
  dependencies = {
    "fredrikaverpil/neotest-golang",
  },
  opts = {
    -- log_level = 1,
    adapters = {
      ["neotest-golang"] = {
        runner = "gotestsum",
        -- Here we can set options for neotest-golang, e.g.
        -- go_test_args = { "-v", "-race", "-count=1", "-timeout=60s" },
        -- dap_go_enabled = true, -- requires leoluz/nvim-dap-go
      },
    },
  },
}
