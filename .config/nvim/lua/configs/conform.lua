local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "biome-check", "biome" },
    html = { "biome-check", "biome" },
    jsonc = { "biome-check", "biome" },
    json = { "biome-check", "biome" },
    javascript = { "biome-check", "biome" },
    typescript = { "biome-check", "biome" },
    jsx = { "biome-check", "biome" },
    tsx = { "biome-check", "biome" },
    go = { "gofumpt", "goimports-reviser", "golines" },
    python = { "ruff_format", "ruff_fix", "ruff_organize_imports" },
    rust = { "rustfmt" },
    zig = { "zigfmt" },
    odin = { "odinfmt" },
    nix = { "nixfmt" },
    dart = { "dart_format" },
    cpp = { "clang-format" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
