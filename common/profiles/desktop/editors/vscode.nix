{
  config,
  lib,
  pkgs,
  ...
}: let
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
    "workbench.activityBar.visible" = false;
    "workbench.statusBar.visible" = true;
    "window.menuBarVisibility" = "toggle";
    "explorer.openEditors.visible" = 0;
    "workbench.iconTheme" = "vscode-icons";
    "git.ignoreLegacyWarning" = true;
    "telemetry.enableCrashReporter" = false;
    "telemetry.enableTelemetry" = false;
    "workbench.colorTheme" = "Monokai";
    "workbench.startupEditor" = "newUntitledFile";
    "search.exclude" = {
      "**/*.o.dep" = true;
      "**/bower_components" = true;
      "**/dist" = true;
      "**/node_modules" = true;
    };
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
    "tabnine.experimentalAutoImports" = true;
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
    home.activation.update-code-settings = config.lib.dag.entryAfter ["writeBoundary"] ''
      mkdir -p ~/.config/Code/User/
      if [ ! -f ~/.config/Code/User/settings.json ]
      then
          echo "{}" > ~/.config/Code/User/settings.json
      fi

      # Store it as a variable to avoid race condition
      UPDATED_SETTINGS=$(jq -s 'reduce .[] as $item ({}; . * $item)' ~/.config/Code/User/settings.json ${pkgs.writeText "settings.json" (builtins.toJSON settings)})
      echo "$UPDATED_SETTINGS" > ~/.config/Code/User/settings.json
    '';
  };
}
