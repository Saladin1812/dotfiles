{
  pkgs,
  ...
}:
let
  unreal-clangd = pkgs.vscode-utils.buildVscodeExtension {
    pname = "unreal-clangd";
    version = "3.4.1";
    src = pkgs.fetchurl {
      url = "https://github.com/boocs/unreal-clangd/releases/download/v3.4.1/unreal-clangd-3.4.1.vsix";
      hash = "sha256-g3KxFvnI/8t4KB1JynbxYGtCfdaoiKnmZhg9u7owXFU=";
    };
    vscodeExtPublisher = "boocs";
    vscodeExtName = "unreal-clangd";
    vscodeExtUniqueId = "boocs.unreal-clangd";
  };
in
{
  enable = true;
  package = pkgs.vscode-fhs;
  profiles.default.extensions = (pkgs.nix4vscode.forVscode [
    "vscodevim.vim"
    "danielgavin.ols"
    "charliermarsh.ruff"
    "enkia.tokyo-night"
    "esbenp.prettier-vscode"
    "jnoortheen.nix-ide"
    "mkhl.direnv"
    "astral-sh.ty"
    "llvm-vs-code-extensions.vscode-clangd"
    "ms-vscode.cpptools"
    "captncaps.ue4-snippets"
    "golang.go"
    "tamasfe.even-better-toml"
    "rust-lang.rust-analyzer"
    "vadimcn.vscode-lldb"
    "fill-labs.dependi"
    "redhat.vscode-yaml"
    "ziglang.vscode-zig"
    "pkief.material-icon-theme"
  ]) ++ [ unreal-clangd ];
  profiles.default.userSettings = {
    "workbench.startupEditor" = "none";
    "window.customTitleBarVisibility" = "never";
    "window.titleBarStyle" = "custom";
    "window.commandCenter" = true;
    "workbench.colorTheme" = "Tokyo Night";
    "workbench.iconTheme" = "material-icon-theme";
    "material-icon-theme.hidesExplorerArrows" = true;
    "workbench.tree.enableStickyScroll" = false;
    "workbench.tree.renderIndentGuides" = "always";
    "workbench.tree.indent" = 8;
    "explorer.compactFolders" = false;
    "explorer.confirmDragAndDrop" = false;
    "explorer.confirmDelete" = false;
    "extensions.ignoreRecommendations" = true;
    "files.autoSave" = "off";
    "editor.formatOnSave" = true;
    "telemetry.telemetryLevel" = "off";
    "editor.suggest.insertMode" = "replace";
    "editor.minimap.enabled" = false;
    "breadcrumbs.enabled" = false;
    "workbench.activityBar.location" = "hidden";
    "workbench.editor.showTabs" = "single";
    "workbench.statusBar.visible" = true;
    "workbench.tips.enabled" = false;
    "update.mode" = "none";
    "update.showReleaseNotes" = false;
    "zenMode.hideLineNumbers" = false;
    "editor.lineNumbers" = "relative";
    "vim.leader" = "<Space>";
    "vim.hlsearch" = true;
    "editor.fontFamily" = "JetBrainsMono Nerd Font";
    "editor.fontSize" = 16;
    "editor.fontLigatures" = true;
    "editor.cursorBlinking" = "solid";
    "chat.disableAIFeatures" = true;
    "window.zoomLevel" = 1.25;
    "vim.normalModeKeyBindingsNonRecursive" = [
      {
        "before" = [ "<S-tab>" ];
        "commands" = [ ":bprevious" ];
      } # switch buffers/ tabs
      {
        "before" = [ "tab" ];
        "commands" = [ ":bnext" ];
      }
      {
        "before" = [
          "leader"
          "v"
        ];
        "commands" = [ ":vsplit" ];
      } # split panes
      {
        "before" = [
          "leader"
          "s"
        ];
        "commands" = [ ":split" ];
      }
      {
        "before" = [ "<C-h>" ];
        "commands" = [ "workbench.action.focusLeftGroup" ];
      } # move across panes
      {
        "before" = [ "<C-j>" ];
        "commands" = [ "workbench.action.focusBelowGroup" ];
      }
      {
        "before" = [ "<C-k>" ];
        "commands" = [ "workbench.action.focusAboveGroup" ];
      }
      {
        "before" = [ "<C-l>" ];
        "commands" = [ "workbench.action.focusRightGroup" ];
      }
      {
        "before" = [
          "leader"
          "w"
        ];
        "commands" = [ ":w!" ];
      } # quick commands
      {
        "before" = [
          "leader"
          "q"
        ];
        "commands" = [ ":q!" ];
      }
      {
        "before" = [
          "leader"
          "x"
        ];
        "commands" = [ ":x!" ];
      }
      {
        "before" = [
          "["
          "d"
        ];
        "commands" = [ "editor.action.marker.prev" ];
      } # move across warnings / errors
      {
        "before" = [
          "]"
          "d"
        ];
        "commands" = [ "editor.action.marker.next" ];
      }
      {
        "before" = [
          "leader"
          "c"
          "a"
        ];
        "commands" = [ "editor.action.quickFix" ];
      } # quick actions
      {
        "before" = [
          "leader"
          "f"
        ];
        "commands" = [ "workbench.action.quickOpen" ];
      } # find files
      {
        "before" = [
          "leader"
          "p"
        ];
        "commands" = [ "editor.action.formatDocument" ];
      } # format
      {
        "before" = [
          "g"
          "h"
        ];
        "commands" = [ "editor.action.showDefinitionPreviewHover" ];
      } # preview however definition
    ];

    "vim.visualModeKeyBindings" = [
      {
        "before" = [ "<" ];
        "commands" = [ "editor.action.outdentLines" ];
      } # indent
      {
        "before" = [ ">" ];
        "commands" = [ "editor.action.indentLines" ];
      }
      {
        "before" = [ "J" ];
        "commands" = [ "editor.action.moveLinesDownAction" ];
      } # move complete lines in visual mode
      {
        "before" = [ "K" ];
        "commands" = [ "editor.action.moveLinesUpAction" ];
      }
      {
        "before" = [
          "leader"
          "c"
        ];
        "commands" = [ "editor.action.commentLine" ];
      } # comment line
    ];

    "[jsonc]" = {
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
    };
    "[html]" = {
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
    };
    "[css]" = {
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
    };
    "[typescript]" = {
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
    };
    "[javascript]" = {
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
    };

    "[python]" = {
      "editor.formatOnSave" = true;
      "editor.codeActionsOnSave" = {
        "source.fixAll" = "explicit";
        "source.organizeImports" = "explicit";
      };
      "editor.defaultFormatter" = "charliermarsh.ruff";
    };

    "nix.enableLanguageServer" = true;
    "C_Cpp.intelliSenseEngine" = "disabled";
    "zig.zls.enabled" = "on";
    "cmake.useCmakePresets" = "always";
    "nix.serverPath" = "nil";
    "nix.serverSettings" = {
      "nil" = {
        "formatting" = {
          "command" = [ "nixfmt" ];
        };
      };
    };
  };

  profiles.default.keybindings = [
    {
      key = "ctrl+shift+n";
      command = "workbench.action.terminal.focusNext";
      when = "terminalFocus";
    }
    {
      key = "ctrl+shift+b";
      command = "workbench.action.terminal.focusPrevious";
      when = "terminalFocus";
    }
    {
      key = "ctrl+shift+h";
      command = "workbench.action.togglePanel";
    }
    {
      key = "ctrl+shift+a";
      command = "workbench.action.terminal.new";
      when = "terminalFocus";
    }
    {
      key = "ctrl+shift+w";
      command = "workbench.action.terminal.kill";
      when = "terminalFocus";
    }
    {
      command = "workbench.action.toggleSidebarVisibility";
      key = "ctrl+n";
    }
    {
      command = "workbench.files.action.focusFilesExplorer";
      key = "ctrl+n";
      when = "editorTextFocus";
    }
    {
      command = "explorer.newFile";
      key = "a";
      when = "filesExplorerFocus && !inputFocus";
    }
    {
      command = "renameFile";
      key = "r";
      when = "filesExplorerFocus && !inputFocus";
    }
    {
      command = "explorer.newFolder";
      key = "shif+a";
      when = "explorerViewletFocus";
    }
    {
      command = "workbench.action.newWindow";
      key = "ctrl+shif+n";
      when = "!terminalFocus";
    }
    {
      command = "deleteFile";
      key = "d";
      when = "filesExplorerFocus && !inputFocus";
    }
    {
      command = "workbench.action.toggleZenMode";
      key = "ctrl+z";
    }
    {
      key = "tab";
      command = "-acceptSelectedSuggestion";
      when = "suggestWidgetHasFocusedSuggestion && suggestWidgetVisible && textInputFocus";
    }

    {
      key = "tab";
      command = "selectNextSuggestion";
      when = "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus && !inSnippetMode";
    }
    {
      key = "shift+tab";
      command = "selectPrevSuggestion";
      when = "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus && !inSnippetMode";
    }
  ];
}
