-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local servers = {
  "html",
  "cssls",
  "pyright",
  "zls",
  "gopls",
  "taplo",
  "nil_ls",
  "ols",
  "omnisharp",
  "ts_ls",
  "clangd",
  "gdscript",
}
local util = require "lspconfig/util"

vim.lsp.enable(servers)

-- go
vim.lsp.config.gopls = {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gosum", "gowork", "gotmpl" },
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
      },
    },
  },
}

vim.lsp.config.ts_ls = {
  init_options = {
    preferences = {
      disableSuggestions = true,
    },
  },
}
