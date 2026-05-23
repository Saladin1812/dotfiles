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
    end,
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
    "Mathijs-Bakker/godotdev.nvim",
    dependencies = { "nvim-dap", "nvim-dap-ui", "nvim-treesitter" },
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
  {
    "mbwilding/UnrealEngine.nvim",
    lazy = false,
    dependencies = {
      -- optional, this registers the Unreal Engine icon to .uproject files
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      {
        "<leader>ug",
        function()
          require("unrealengine.commands").generate_lsp()
        end,
        desc = "UnrealEngine: Generate LSP",
      },
      {
        "<leader>ub",
        function()
          require("unrealengine.commands").build()
        end,
        desc = "UnrealEngine: Build",
      },
      {
        "<leader>ur",
        function()
          require("unrealengine.commands").rebuild()
        end,
        desc = "UnrealEngine: Rebuild",
      },
      {
        "<leader>uo",
        function()
          require("unrealengine.commands").open()
        end,
        desc = "UnrealEngine: Open Editor",
      },
      {
        "<leader>uc",
        function()
          require("unrealengine.commands").clean()
        end,
        desc = "UnrealEngine: Clean",
      },
      {
        "<leader>ue",
        function()
          require("unrealengine.commands").build_engine()
        end,
        desc = "UnrealEngine: Link Plugin - Build Engine",
      },
      {
        "<leader>up",
        function()
          require("unrealengine.commands").build_plugin()
        end,
        desc = "UnrealEngine: Build Plugin",
      },
    },
    -- Optional, this will update and build the Unreal Engine plugin on update
    build = function()
      -- Path required to be passed in
      require("unrealengine.commands").build_engine {
        engine_path = "/home/saladin/Repos/Unreal/Engines/Linux_Unreal_Engine_5.7.4",
      }
    end,
    opts = {
      auto_generate = true, -- Auto generates LSP info when detected in CWD | default: false
      auto_build = true, -- Auto builds on save | default: false
      engine_path = "/home/saladin/Repos/Unreal/Engines/Linux_Unreal_Engine_5.7.4", -- Path to your UnrealEngine source directory
      build_type = "Development", -- Build type: "DebugGame", "Development", or "Shipping"
      with_editor = true, -- Build with editor | default: true
      register_icon = true, -- Register Unreal Engine icon for .uproject files | default: true
      register_filetypes = true, -- Register .uproject and .uplugin as JSON | default: true
      close_on_success = true, -- Close terminal split on successful builds | default: true
      environment_variables = nil, -- Environment variables to pass when launching editor (Linux/Mac only)
    },
  },
  {
    "Saladin1812/roundtable.nvim",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = true,
    lazy = false,
  },
}
