return {
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      local lint = require("lint")
      local mlint = lint.linters["markdownlint-cli2"]
      if not mlint then
        return
      end

      local global_config = vim.fn.expand("~/.markdownlint.json")
      local config_names = {
        ".markdownlint-cli2.jsonc",
        ".markdownlint-cli2.yaml",
        ".markdownlint-cli2.cjs",
        ".markdownlint-cli2.mjs",
        ".markdownlint.jsonc",
        ".markdownlint.json",
        ".markdownlint.yaml",
        ".markdownlint.yml",
        ".markdownlint.cjs",
        ".markdownlint.mjs",
      }

      local function resolve_config()
        local bufname = vim.api.nvim_buf_get_name(0)
        local start = bufname ~= "" and vim.fs.dirname(bufname) or vim.fn.getcwd()
        local found = vim.fs.find(config_names, { upward = true, path = start })[1]
        return found or global_config
      end

      mlint.args = vim.list_extend({ "--config", resolve_config }, mlint.args or {})
    end,
  },
}
