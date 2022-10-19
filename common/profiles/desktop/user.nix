{
  config,
  lib,
  pkgs,
  ...
}: let
  users = config.users.users;
  defaultLocale = config.i18n.defaultLocale;
  # fzf to find path for project and run cmd
  projectCmd = cmd: "P=$(ls -d $HOME/Projects/*/*/* | fzf); if [ ! -z \"$P\" ]; then; ${cmd}; fi";
in {
  # Default to zsh as shell on desktop
  users.users.mats.shell = pkgs.zsh;

  # Home config for mats on desktop profile
  home-manager.config = {config, ...}: {
    home.sessionVariables.EDITOR = "vim";

    programs = {
      command-not-found.enable = false; # Does not work with flakes
      # Enable direnv
      direnv.enable = true;
      # Configure git defaults
      git = {
        enable = true;
        package = pkgs.gitFull;
        userName = users.${config.home.username}.description; # Use the user account name
        userEmail = "${config.home.username}@mats.sh"; # Just put the username on my domain for now
        delta.enable = true;
        extraConfig = {
          init.defaultBranch = "master";
          pull.rebase = true;
        };
      };
      # Setup fzf for fuzzing
      fzf = {
        enable = true;
        enableZshIntegration = true;
      };
      # Configure zsh
      zsh = {
        enable = true;
        enableAutosuggestions = true;
        enableCompletion = true;
        enableSyntaxHighlighting = true;
        enableVteIntegration = true;
        oh-my-zsh.enable = true;
        # Custom theme
        initExtra = ''
          # Get nixos-rebuild perl scripts to shutup
          export LANG=${defaultLocale}
          export LC_ALL=${defaultLocale}

          setopt PROMPT_SUBST
          if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="white"; fi
          PROMPT="%{$fg[$NCOLOR]%}%n%{$reset_color%}@%{$fg[white]%}%m %{$fg[blue]%}%B%c/%b%{$reset_color%} %(\!.#.$) "
        '';
      };
    };

    # Shell aliases
    home.shellAliases = rec {
      # CLI tools
      ls = "exa";
      cat = "bat";
      l = "exa -lh";
      # Shortcuts
      t = "thunar .";
      # Dev
      c = "code ."; # Open up the folder in VSCode
      # Git shortcuts
      gd = "git diff";
      gl = "git log --graph";
      ga = "git log --graph --all";
      gf = "git fetch";
      gp = "git pull";
      gc = "git commit";
      # Go to project directory
      projects = projectCmd "cd $P";
      p = projects;
      # Open project in code
      op = projectCmd "code $P";
    };

    # Setup nextcloud-client
    services.nextcloud-client = {
      enable = true;
    };
    systemd.user.services.nextcloud-client = {
      Service.ExecStartPre = lib.mkForce "${pkgs.coreutils}/bin/sleep 10";
      Unit = {
        After = lib.mkForce ["graphical-session.target"];
        PartOf = lib.mkForce [];
      };
    };
  };

  # Add mats to home-manager
  home-manager.mainUsers = ["mats"];

  # Ensure autocompletion gets linked
  environment.pathsToLink = ["/share/zsh"];
}
