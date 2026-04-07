-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "tokyonight",
  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
  },
}

M.nvdash = { load_on_startup = true }
M.ui = {
  tabufline = {
    lazyload = false,
  },
}

M.mason = {
  pkgs = { "rust-analyzer", "gopls" },
  skip = { "clangd" },
}

vim.g.lua_snippets_path = vim.fn.stdpath "config" .. "/lua/snippets"

return M
