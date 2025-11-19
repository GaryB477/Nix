{ pkgs, config, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    mutableExtensionsDir = false;
    profiles = {
      default = {
        enableUpdateCheck = false;
        enableExtensionUpdateCheck = false;

        # I try to make the key bindings as similar as possible to my nvim setup
        keybindings = [
          {
            "key" = "ctrl+h";
            "command" = "workbench.action.navigateLeft";
          }
          {
            "key" = "ctrl+l";
            "command" = "workbench.action.navigateRight";
          }
          {
            "key" = "ctrl+k";
            "command" = "workbench.action.navigateUp";
          }
          {
            "key" = "ctrl+j";
            "command" = "workbench.action.navigateDown";
          }
          {
            "key" = "enter";
            "command" = "-renameFile";
            "when" =
              "filesExplorerFocus && foldersViewVisible && !explorerResourceIsRoot && !explorerResourceReadonly && !inputFocus";
          }
          {
            "key" = "enter";
            "command" = "filesExplorer.openFilePreserveFocus";
            "when" = "filesExplorerFocus && foldersViewVisible && !explorerResourceIsFolder && !inputFocus";
          }
          {
            "key" = "a";
            "command" = "explorer.newFile";
            "when" = "filesExplorerFocus && foldersViewVisible && explorerResourceIsFolder && !inputFocus";
          }
          {
            "key" = "ctrl+enter";
            "command" = "code-runner.run";
          }
          {
            "key" = "ctrl+p";
            "command" = "selectPrevSuggestion";
          }
          {   
            "key" = "ctrl+n"; 
            "command" = "selectNextSuggestion";
            "when" = "suggestWidgetVisible";
          }
          {   
            "key" = "escape"; 
            "command" = "hideSuggestWidget";
            "when" = "suggestWidgetVisible";
          }
          {
            "key" = "shift shift";
            "command" = "workbench.action.quickOpen";
          }
          {
            "key" = "f2";
            "command" = "editor.action.revealDefinition";
          }
          {
            "key" = "ctrl+shift+alt+l";
            "command" = "editor.action.formatDocument";
          }
        ];
        userSettings = {

          # theming
          "editor.semanticHighlighting.enabled" = true;
          "terminal.integrated.minimumContrastRatio" = 1;
          "window.titleBarStyle" = "custom";
          # font and theme is set by stylix

          # editor basics
          "editor.tabSize" = 2;
          "editor.lineNumbers" = "relative";
          "files.autoSave" = "afterDelay";
          "files.insertFinalNewline" = true;
          "editor.fontLigatures" = true;
          "editor.minimap.enabled" = false;
          "workbench.editor.showTabs" = "multiple"; # no tabs (like my emacs and vim)
          "window.zoomLevel" = 1;

          # disable updates & synching
          "extensions.autoUpdate" = false;
          "extensions.autoCheckUpdates" = false;
          "update.mode" = "none";
          "settingsSync.keybindingsPerPlatform" = false;
          "extensions.ignoreRecommendations" = true;

          # svelte extension config
          "svelte.enable-ts-plugin" = true;

          # JS/TS setup
          "eslint.workingDirectories" = [ { "mode" = "auto"; } ];
          # "eslint.format.enable" = true;
          # "[typescriptreact]" = {
          #   "editor.defaultFormatter" = "dbaeumer.vscode-eslint";
          # };
          # "[typescript]" = {
          #   "editor.defaultFormatter" = "dbaeumer.vscode-eslint";
          # };

          # vim plugin setup
          "vim.easymotion" = true;
          "vim.incsearch" = true;
          "vim.useSystemClipboard" = true;
          "vim.useCtrlKeys" = true;
          "vim.hlsearch" = true;
          "vim.insertModeKeyBindings" = [
            {
              "before" = [
                "j"
                "j"
              ];
              "after" = [ "<Esc>" ];
            }
          ];
          "vim.visualModeKeyBindings" = [
            {
                "before" = [
                    "<Leader>"
                    "c"
                ];
                "commands" = [
                    "editor.action.commentLine"
                ];
            }
          ];

          "vim.normalModeKeyBindingsNonRecursive" = [
            {
              "before" = [
                  "<Leader>"
                  "c"
              ];
              "commands" = [
                  "editor.action.commentLine"
              ];
            }
            {
              "before" = [
                  "<Leader>"
                  "r"
              ];
              "commands" = [
                  "editor.action.rename"
              ];
            }
            {
              "before" = [
                  "<Leader>"
                  "j"
              ];
              "commands" = [
                  "workbench.action.navigateBack"
              ];
            }
            {
              "before" = [
                  "<Leader>"
                  "k"
              ];
              "commands" = [
                  "workbench.action.navigateForward"
              ];
            }
            {
              "before" = [
                  "<Leader>"
                  "l"
              ];
              "commands" = [
                  "workbench.action.navigateEditorGroups"
              ];
            }
            {
              "before" = [
                  "<Leader>"
                  "f"
              ];
              "commands" = [
                  "editor.foldRecursively"
              ];
            }
            {
              "before" = [
                  "<Leader>"
                  "f"
                  "f"
              ];
              "commands" = [
                  "editor.foldAll"
              ];
            }
            {
              "before" = [
                  "<Leader>"
                  "o"
              ];
              "commands" = [
                  "editor.unfoldRecursively"
              ];
            }
            {
              "before" = [
                  "<C-u>"
              ];
              "after" = [
                  "1"
                  "0"
                  "k"
              ];
            }
            {
              "before" = [
                  "<C-d>"
              ];
              "after" = [
                  "1"
                  "0"
                  "j"
              ];
            }
            {
              "before" = [
                  "<Leader>"
                  "w"
              ];
              "commands" = [
                  "editor.action.marker.next"
              ];
            }
          ];
          "vim.leader" = "<space>";
          "vim.handleKeys" = {
            "<C-a>" = false;
            "<C-f>" = false;
          };
          "[csharp]" = {
            "editor.defaultFormatter" = "csharpier.csharpier-vscode";
          };
          "[jsonc]" = {
            "editor.defaultFormatter" = "vscode.json-language-features";
          };
          "[html]" = {
            "editor.defaultFormatter" = "vscode.html-language-features";
          };
          "[json]" = {
            "editor.defaultFormatter" = "vscode.json-language-features";
          };
          "[javascript]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
          };
          "ilspy.defaultOutputLanguage" = "C# 11.0 / VS 2022.4";
          "files.eol" = "\n";
          "editor.formatOnSave" = false;
          "python.analysis.typeCheckingMode" = "standard";
          "editor.fontSize" = pkgs.lib.mkForce 12.0;
          "chat.editor.fontSize" = pkgs.lib.mkForce 12.0;
          "debug.console.fontSize" = pkgs.lib.mkForce 12.0;
          "markdown.preview.fontSize" = pkgs.lib.mkForce 12.0;
          "terminal.integrated.fontSize" = pkgs.lib.mkForce 12.0;
          "workbench.sideBar.location" = "right";

          "github.copilot.enable" = {
            "*" = true; # disable suggestions
            "inlineSuggestions" = true; # disable inline-suggestions
          };
          "chat.agent.enabled" = true;
        };

        extensions =
          # From vscode overlay
          with pkgs.vscode-marketplace;
          [
            # General repo setups
            editorconfig.editorconfig # needed?
            streetsidesoftware.code-spell-checker
            marcovr.actions-shell-scripts

            # Make VSCode more like vim and emacs
            vscodevim.vim

            # Python
            ms-python.python
            ms-python.debugpy

            # Lua
            sumneko.lua

            # Nix
            jnoortheen.nix-ide

            # Docker / DevOps / Cloud
            github.vscode-github-actions
            ashishalex.dataform-lsp-vscode

            # XML, YAML, TOML
            redhat.vscode-yaml
            tamasfe.even-better-toml
            redhat.vscode-xml
            bluebrown.yamlfmt

            # Shell
            timonwong.shellcheck
          ]
          ++ (with pkgs.vscode-extensions; [
            github.vscode-pull-request-github

            github.copilot
            github.copilot-chat
          ]
        );
      };
    };
  };
}
