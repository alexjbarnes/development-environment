return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "gopls",
          "rust_analyzer",
          "dockerls",
          "terraformls",
          "jsonls",
          "yamlls",
          "hadolint"
        },
        automatic_installation = true,
      })
    end,
  },
}
