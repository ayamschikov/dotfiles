return {
  "nvim-neotest/neotest",
  lazy = true,
  dependencies = {
    "olimorris/neotest-rspec",
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-rspec")({
          rspec_cmd = function()
            return {
              "docker",
              "compose",
              "exec",
              "-e",
              "RAILS_ENV=test",
              "web",
              "bundle",
              "exec",
              "rspec",
            }
          end,

          transform_spec_path = function(path)
            local prefix = require("neotest-rspec").root(path)
            return string.sub(path, string.len(prefix) + 2, -1)
          end,

          results_path = "tmp/rspec.output",
          formatter = "json",
        }),
      },
    })
  end,
}
