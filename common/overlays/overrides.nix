{...}: {
  nixpkgs.overlays = [
    (self: super: {
      gnome =
        super.gnome
        // {
          # Fix gnome-keyring 100% cpu usage
          gnome-keyring = super.gnome.gnome-keyring.override {
            glib = super.glib.overrideAttrs (oldAttrs: {
              patches =
                oldAttrs.patches
                ++ [
                  (self.fetchpatch {
                    url = "https://gitlab.gnome.org/GNOME/glib/-/commit/2a36bb4b7e46f9ac043561c61f9a790786a5440c.patch";
                    sha256 = "sha256-b77Hxt6WiLxIGqgAj9ZubzPWrWmorcUOEe/dp01BcXA=";
                  })
                ];
            });
          };
        };
    })
  ];
}
