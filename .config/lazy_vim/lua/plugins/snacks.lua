return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        files = {
          hidden = true,
          ignored = true,
          exclude = { ".git", "node_modules" },
        },
        sources = {
          explorer = {
            hidden = true,
            ignored = true,
            exclude = { ".git" },
          },
        },
      },
    },
  },
}
