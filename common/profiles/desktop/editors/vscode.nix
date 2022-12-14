{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  # VSCode extensions
  vscodeExtensions = with pkgs.vscode-extensions;
    [
      bungcip.better-toml
      ms-vscode.cpptools
      ms-dotnettools.csharp
      vadimcn.vscode-lldb
      editorconfig.editorconfig
      james-yu.latex-workshop
      bbenoist.nix
      arrterian.nix-env-selector
      matklad.rust-analyzer
      zxh404.vscode-proto3
    ]
    ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      # Comment anchors
      {
        name = "comment-anchors";
        publisher = "ExodiusStudios";
        version = "1.9.6";
        sha256 = "sha256-e3M0ooXmiVSjknSIV8iPFR9hhyRXyrTQHt4G/I17+/0=";
      }
      # Shader languages support for VS Code
      {
        name = "shader";
        publisher = "slevesque";
        version = "1.1.5";
        sha256 = "sha256-Pf37FeQMNlv74f7LMz9+CKscF6UjTZ7ZpcaZFKtX2ZM=";
      }
      # VSCode icons
      {
        name = "vscode-icons";
        publisher = "vscode-icons-team";
        version = "11.18.0";
        sha256 = "sha256-aP3YIS6tAmY0iG2sHTt3W1KTihpnKRk0mc7cmKxFx2Y=";
      }
    ];
  # VSCode user settings
  settings = {
    # Theming
    "workbench.colorTheme" = "Monokai";
    # Override monokai colors to make the theme darker
    "workbench.colorCustomizations" = {
      "[Monokai]" = {
        # Titlebar
        "titleBar.activeBackground" = "#111";
        # Menu
        "menu.background" = "#111";
        "menu.selectionBackground" = "#222";
        "menubar.selectionBackground" = "#222";
        # Editor
        "editor.background" = "#141414";
        "editor.lineHighlightBackground" = "#222";
        # Activity bar
        "activityBar.background" = "#141414";
        "activityBar.activeBorder" = "#333";
        "badge.background" = "#222";
        # Sidebar
        "sideBar.background" = "#121212";
        "sideBarSectionHeader.background" = "#141414";
        # Tabs
        "tab.activeBackground" = "#141414";
        "tab.inactiveBackground" = "#111";
        "editorGroupHeader.tabsBackground" = "#111";
        # Statusbar
        "statusBar.background" = "#121212";
        "statusBar.noFolderBackground" = "#121212";
        # Input
        "quickInput.background" = "#111";
        "quickInputList.focusBackground" = "#222";
        "editorWidget.background" = "#111";
        "input.background" = "#222";
        "list.focusBackground" = "#222";
        "list.hoverBackground" = "#222";
        "list.inactiveSelectionBackground" = "#222";
        "list.activeSelectionBackground" = "#222";
        # Misc
        "dropdown.background" = "#222";
        "toolbar.hoverBackground" = "#333";
      };
    };
    "workbench.iconTheme" = "vscode-icons"; # Icons
    # Enable custom dialog / tittle bar style and command center
    "window.dialogStyle" = "custom";
    "window.titleBarStyle" = "custom";
    "window.commandCenter" = true;
    # Start maximized
    "window.newWindowDimensions" = "maximized";
    "window.restoreFullscreen" = true;
    # Disable bloat in UI
    "workbench.activityBar.visible" = false;
    "workbench.statusBar.visible" = true;
    "explorer.openEditors.visible" = 0;
    "workbench.startupEditor" = "newUntitledFile";
    "git.ignoreLegacyWarning" = true;
    "search.exclude" = {
      "**/*.o.dep" = true;
      "**/bower_components" = true;
      "**/dist" = true;
      "**/node_modules" = true;
    };
    # Kill telemetry
    "telemetry.enableCrashReporter" = false;
    "telemetry.enableTelemetry" = false;
    "telemetry.telemetryLevel" = "off";
    "git.enableSmartCommit" = true;
    "typescript.check.npmIsInstalled" = false;
    "files.exclude" = {
      ".tscache/" = true;
      "**/*.o" = true;
      "dist/" = true;
      "node_modules/" = true;
    };
    "git.countBadge" = "off";
    "git.decorations.enabled" = false;
    "extensions.ignoreRecommendations" = true;
    "commentAnchors.tags.displayInGutter" = false;
    "rust.clippy_preference" = "on";
    "rust-client.autoStartRls" = false;
    "rust-analyzer.cargo.loadOutDirsFromCheck" = true;
    "rust-analyzer.checkOnSave.enable" = true;
    "rust-analyzer.checkOnSave.allTargets" = false;
    "rust-analyzer.diagnostics.enableExperimental" = false;
    "rust-analyzer.inlayHints.parameterHints" = false;
    "rust-analyzer.inlayHints.chainingHints" = false;
    "terminal.integrated.fontFamily" = "DejaVu Sans Mono";
    "terminal.integrated.rendererType" = "dom";
    "[dart]" = {
      "editor.formatOnSave" = true;
      "editor.formatOnType" = true;
      "editor.rulers" = [
        80
      ];
      "editor.selectionHighlight" = false;
      "editor.suggest.snippetsPreventQuickSuggestions" = false;
      "editor.suggestSelection" = "first";
      "editor.tabCompletion" = "onlySnippets";
      "editor.wordBasedSuggestions" = false;
    };
    "elixirLS.suggestSpecs" = false;
    "rust.racer_completion" = false;
    "rust.all_targets" = false;
    "mesonbuild.configureOnOpen" = true;
    "clangd.onConfigChanged" = "restart";
    "omnisharp.path" = "${pkgs.omnisharp-roslyn}/bin/OmniSharp";
    "latex-workshop.view.pdf.viewer" = "tab";
    "explorer.confirmDelete" = false;
    "workbench.editorAssociations" = {
      "*.ipynb" = "jupyter-notebook";
    };
    "redhat.telemetry.enabled" = false;
    "editor.minimap.enabled" = false;
    "workbench.editor.untitled.hint" = "hidden";
    "terminal.integrated.tabs.location" = "left";
    "notebook.cellToolbarLocation" = {
      "default" = "right";
      "jupyter-notebook" = "left";
    };
  };
in {
  # Install vscode with extensions already installed
  environment.systemPackages = with pkgs; [
    (vscode-with-extensions.override {
      inherit vscodeExtensions;
    })
  ];

  # Use home-manager to update the user settings
  home-manager.config = {
    pkgs,
    config,
    ...
  }: {
    # Update the settings.json
    home.activation.update-code-settings = config.lib.dag.entryAfter ["writeBoundary"] (mergeJson "~/.config/Code/User/settings.json" settings);
  };
}
