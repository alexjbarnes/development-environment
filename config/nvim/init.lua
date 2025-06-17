-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Mason setup
require("mason").setup()

-- Mason LSP config
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "dockerls", "gopls", "rust_analyzer", "terraformls", "jsonls", "yamlls" },
  automatic_installation = true,
})

-- Set relative line numbers off
vim.opt.number = true
vim.opt.relativenumber = false
