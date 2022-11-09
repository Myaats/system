{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  # Gnome extensions to use
  extensions = with pkgs;
  with gnomeExtensions;
    [
      always-show-titles-in-overview
      appindicator
      gsconnect
      # inhibit-suspend # - Seems to be slightly bugged
      mpris-indicator-button
      just-perfection
      status-area-horizontal-spacing
      tailscale-status
      transparent-top-bar-adjustable-transparency
      user-themes
    ]
    # Add improved OSK extension for touch devices
    ++ (
      if builtins.elem "touch" config.device.features
      then [gnomeExtensions.improved-osk]
      else []
    )
    # Toggle battery conservation mode on ideapad devices
    ++ (
      if builtins.elem "ideapad" config.device.features
      then [gnomeExtensions.ideapad]
      else []
    );
  # UUIDs of gnome extensions to enable
  extensionUuids = [];
  # Default background
  background = config.assets.bg;
  # Activities icon
  activitiesIcon = config.assets.app-grid;
  # Custom keybinds
  keybinds = [
    {
      binding = "<Super>Tab";
      command = "guake -t";
      name = "guake";
    }
    {
      binding = "<Super>c";
      command = "kgx";
      name = "console";
    }
    {
      binding = "<Super>z";
      command = "guake --show -e \"op && exit\" -r \"Open project\"";
      name = "open project";
    }
    {
      binding = "<Super>x";
      command = "qalculate-gtk";
      name = "qalculate";
    }
  ];
in {
  services.xserver = {
    enable = true;
    desktopManager = {
      # Enable gnome
      gnome.enable = true;
      # Disable xterm
      xterm.enable = false;
    };
    displayManager = {
      # Use gdm as displaymanager
      gdm = {
        enable = true;
        wayland = mkDefault true; # Default to wayland
      };
    };
  };

  # Add gnome-related system packages and theme
  environment.systemPackages = with pkgs;
    [
      gnome.dconf-editor
      gnome.gnome-tweaks
      gnome.gnome-font-viewer
      gnome.adwaita-icon-theme
      xfce.thunar # Thunar is better than nautilus, imo
      # Theme
      flat-remix-icon-theme
      flat-remix-gtk
      # Dropdown terminal
      guake
    ]
    ++ extensions;

  # Avoid install some unneeded gnome apps
  environment.gnome.excludePackages = with pkgs.gnome; [
    totem
    cheese
    geary
    gnome-contacts
    gnome-maps
    gnome-music
  ];

  # Gnome keyring w/ Seahorse UI
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

  # Theme QT5 with GTK
  qt5 = {
    enable = true;
    platformTheme = "gtk2";
    style = "gtk2";
  };

  # Open port for GSConnect
  networking.firewall.allowedTCPPortRanges = [
    {
      from = 1714;
      to = 1764;
    }
  ];
  networking.firewall.allowedUDPPortRanges = [
    {
      from = 1714;
      to = 1764;
    }
  ];

  # Do home-manager spefific configs
  home-manager.config = {lib, ...}:
    with lib;
    with pkgs.gnomeExtensions; {
      # Setup theme
      gtk = {
        enable = true;
        theme.name = "Flat-Remix-GTK-Blue-Darkest-Solid";
        iconTheme.name = "Flat-Remix-Blue-Dark";
      };

      # Configure pointer
      home.pointerCursor = {
        name = "Adwaita";
        package = pkgs.gnome.adwaita-icon-theme;
        size = 16;
      };
      home.pointerCursor.x11.enable = true;

      # GNOME likes to override this one
      xdg.configFile."gtk-3.0/settings.ini".force = true;
      gtk.gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };

      dconf.settings =
        {
          # Shell
          "org/gnome/shell" = {
            enabled-extensions = (map (e: e.extensionUuid or e.uuid) extensions) ++ extensionUuids;
            favorite-apps = ["firefox.desktop" "code.desktop" "thunar.desktop" "org.gnome.Terminal.desktop" "com.spotify.Client.desktop" "com.valvesoftware.Steam.desktop"];
          };

          # Update bindings
          "org/gnome/desktop/wm/keybindings" = {
            switch-to-workspace-1 = ["<Super>1"];
            switch-to-workspace-2 = ["<Super>2"];
            switch-to-workspace-3 = ["<Super>3"];
            switch-to-workspace-4 = ["<Super>4"];
            switch-to-workspace-5 = ["<Super>5"];
            switch-to-workspace-6 = ["<Super>6"];
            switch-to-workspace-7 = ["<Super>7"];
            switch-to-workspace-8 = ["<Super>8"];
            switch-to-workspace-9 = ["<Super>9"];
            switch-windows = ["<Alt>Tab"];
            switch-applications = [];
            # Kill popos-shell conflicting bindings
            move-to-monitor-left = [];
            move-to-workspace-down = [];
            move-to-workspace-up = [];
            move-to-monitor-right = [];

            # Window
            close = ["<Super>q"];
            show-desktop = ["<Super>d"];
            panel-main-menu = ["<Super>Tab"];
          };

          # Media keys
          "org/gnome/settings-daemon/plugins/media-keys" = {
            play = ["<Control>F11"];
            previous = ["<Control>F10"];
            next = ["<Control>F12"];
          };

          # Interface
          "org/gnome/desktop/interface" = {
            enable-animations = false;
            enable-hot-corners = false;
            color-scheme = "prefer-dark";
            font-antialiasing = "rgba";
            font-hinting = "full";
            gtk-theme = "Flat-Remix-GTK-Blue-Darkest-Solid";
            icon-theme = "Flat-Remix-Blue-Dark";
            shot-battery-percentage = true;
          };

          # Background
          "org/gnome/desktop/background" = {
            picture-options = "zoom";
            picture-uri = "file://${background}";
          };

          # Window Manager settings
          "org/gnome/desktop/wm/preferences" = {
            button-layout = "appmenu:minimize,maximize,close";
            num-workspaces = 9;
          };
          "org/gnome/shell/overrides" = {
            dynamic-workspaces = true;
          };
          "org/gnome/shell/app-switcher" = {
            current-workspace-only = true;
          };

          # Extensions just-perfections
          "org/gnome/shell/extensions/just-perfection" = {
            accessibility-menu = false;
            activities-button = true;
            activities-button-icon-path = "file://${activitiesIcon}";
            activities-button-label = false;
            animation = 2; # Fastest
            dash-icon-size = 0; # Provided by shell
            double-super-to-appgrid = true;
            notification-banner-position = 2; # Move notifications to right
            panel-button-padding-size = 6;
            panel-indicator-padding-size = 1;
            startup-status = 0;
          };

          # Extensions transparent top bar
          "com/ftpix/transparentbar" = {
            transparency = 0;
          };

          # Configure guake (dropdown terminal)
          "apps/guake/general" = {
            window-height = 45;
            window-losefocus = true;
            start-fullscreen = false;
            hide-tabs-if-one-tab = true;
            use-popup = false;
            use-trayicon = false;
          };

          # Enable custom keybinds
          "org/gnome/settings-daemon/plugins/media-keys" = {
            custom-keybindings = imap0 (i: b: "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${toString i}/") keybinds;
          };
        }
        # Configure the custom keybinds
        // (builtins.listToAttrs (imap0
          (i: b: {
            name = "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${toString i}";
            value = b;
          })
          keybinds));

      # Init guake on session start so binds work first try
      systemd.user.services.init-guake = {
        Unit = {
          After = ["graphical-session.target"];
          PartOf = ["graphical-session.target"];
        };
        Install.WantedBy = ["graphical-session.target"];
        Service = {
          Type = "oneshot";
          ExecStart = "${pkgs.guake}/bin/guake --hide";
        };
      };
    };

  # Remove the NixOS logo from GDM
  programs.dconf.profiles.gdm = with pkgs; let
    customDconf = writeTextFile {
      name = "gdm-dconf";
      destination = "/dconf/gdm-custom";
      text = ''
        [org/gnome/login-screen]
        logo=""
      '';
    };

    customDconfDb = pkgs.stdenv.mkDerivation {
      name = "gdm-dconf-db";
      buildCommand = ''
        ${dconf}/bin/dconf compile $out ${customDconf}/dconf
      '';
    };
  in (mkOverride 50 (pkgs.stdenv.mkDerivation {
    name = "dconf-gdm-profile";
    buildCommand = ''
      sed '2ifile-db:${customDconfDb}' ${gnome.gdm}/share/dconf/profile/gdm > $out
    '';
  }));
}
