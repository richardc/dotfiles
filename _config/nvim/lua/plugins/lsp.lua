return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        rust_analyzer = {},
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      PATH = "append",
    }
  },
}
