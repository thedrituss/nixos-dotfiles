return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        nil_ls = { mason = false },
        ruff = { mason = false },
        pyright = { mason = false },
        clangd = { mason = false },
      },
    },
  },
}
