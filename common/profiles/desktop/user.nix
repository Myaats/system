{
  config,
  lib,
  pkgs,
  ...
}: {
  # Default to zsh as shell on desktop
  users.users.mats.shell = pkgs.zsh;

  # Home config for mats on desktop profile
  home.users.mats = {
    home.sessionVariables.EDITOR = "vim";

    programs = {
      command-not-found.enable = false; # Does not work with flakes
      # Configure git defaults
      git = {
        enable = true;
        package = pkgs.gitFull;
        userName = "Mats";
        userEmail = "mats@mats.sh";
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
          export LANG=${config.i18n.defaultLocale}
          export LC_ALL=${config.i18n.defaultLocale}

          setopt PROMPT_SUBST
          if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="white"; fi
          PROMPT="%{$fg[$NCOLOR]%}%n%{$reset_color%}@%{$fg[white]%}%m %{$fg[blue]%}%B%c/%b%{$reset_color%} %(\!.#.$) "
        '';
      };
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
  home.mainUsers = ["mats"];

  # Ensure autocompletion gets linked
  environment.pathsToLink = ["/share/zsh"];
}
