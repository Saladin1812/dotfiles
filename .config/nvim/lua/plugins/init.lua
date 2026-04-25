return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "DrKJeff16/project.nvim",
    lazy = false,
    config = function()
    require("project").setup {
      lsp = {
        enabled = true,
        no_fallback = false,
      },
    }
    end
  },

  { import = "nvchad.blink.lazyspec" },
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.keymap = opts.keymap or {}
      opts.keymap["<Tab>"] = {
        function(cmp)
          if cmp.snippet_active { direction = 1 } then
            return cmp.snippet_forward()
          end
        end,
        "select_next",
        "fallback",
      }
      opts.keymap["<S-Tab>"] = {
        function(cmp)
          if cmp.snippet_active { direction = -1 } then
            return cmp.snippet_backward()
          end
        end,
        "select_prev",
        "fallback",
      }
      return opts
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "cmake",
        "cpp",
        "json",
        "go",
        "python",
        "rust",
        "odin",
        "zig",
        "toml",
        "dart",
        "c_sharp",
        "typescript",
        "javascript",
        "tsx",
        "gdscript",
        "godot_resource",
        "gdshader",
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    lazy = false,
    config = function()
      require("treesitter-context").setup()
    end,
  },

  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap, dapui = require "dap", require "dapui"
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      require("dapui").setup()
    end,
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      ensure_installed = {
        "debugpy",
        "codelldb",
        "delve",
      },
      handlers = {},
    },
  },

  {
    "Civitasv/cmake-tools.nvim",
    lazy = false,
    dependencies = { "preservim/vimux" },
    opts = {
      cmake_executor = { name = "vimux", opts = {} },
      cmake_runner = { name = "vimux", opts = {} },
    },
  },

  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = "mfussenegger/nvim-dap",
    config = function(_, opts)
      require("dap-go").setup(opts)
    end,
  },

  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    opts = {},
    config = function(_, opts)
      require("dap-python").setup(opts)
    end,
  },

  {
    "olexsmir/gopher.nvim",
    ft = "go",
    config = function(_, opts)
      require("gopher").setup(opts)
    end,
    build = function()
      vim.cmd [[silent! GoInstallDeps]]
    end,
  },

  {
    "rust-lang/rust.vim",
    ft = "rust",
    init = function()
      vim.g.rustfmt_autosave = 1
    end,
  },

  {
    "mrcjkb/rustaceanvim",
    version = "^5", -- Recommended
    lazy = false, -- This plugin is already lazy
    ft = "rust",
    config = function()
      vim.g.rustaceanvim = {
        server = {
          on_attach = require("nvchad.configs.lspconfig").on_attach,
        },
      }
    end,
  },

  {
    "nvim-flutter/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("flutter-tools").setup {
        fvm = true,
      }
    end,
  },

  {
    "saecki/crates.nvim",
    ft = { "toml" },
    config = function()
      require("crates").setup()
    end,
  },

  {
    "apyra/nvim-unity-sync",
    lazy = false,
    config = function()
      require("unity.plugin").setup()
    end,
    ft = "cs",
  },

  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },
  {
    "direnv/direnv.vim",
    lazy = false,
  },
}
