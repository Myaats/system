{...}: {
  nixpkgs.overlays = [
    (self: super:
      with super; {
        # Override python packages
        pythonPackagesExtensions =
          super.pythonPackagesExtensions
          ++ [
            (
              python-self: python-super:
                with python-super; {
                  # Add libindicator support to pystray
                  pystray = python-super.pystray.overrideAttrs (oldAttrs: {
                    nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [gobject-introspection];
                    propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [pygobject3 gtk3 libayatana-appindicator];
                  });
                }
            )
          ];
        # Override jellyfin-mpv-shim
        jellyfin-mpv-shim = super.jellyfin-mpv-shim.overrideAttrs (oldAttrs: rec {
          nativeBuildInputs =
            oldAttrs.nativeBuildInputs
            ++ [
              wrapGAppsHook
              gobject-introspection
            ];

          # needed for pystray to access appindicator using GI
          preFixup = ''
            makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
          '';
          dontWrapGApps = true;

          # Copy icons to output
          postInstall = ''
            for s in 16 32 48 64 128 256; do
              mkdir -p $out/share/icons/hicolor/''${s}x''${s}/apps/
              cp $out/lib/${python3.libPrefix}/site-packages/jellyfin_mpv_shim/integration/jellyfin-''${s}.png $out/share/icons/hicolor/''${s}x''${s}/apps/${oldAttrs.pname}.png
            done

            mkdir -p $out/share/applications
            cp ${desktopItem}/share/applications/* $out/share/applications
          '';

          # Create desktop item
          desktopItem = makeDesktopItem {
            name = oldAttrs.pname;
            exec = oldAttrs.pname;
            icon = oldAttrs.pname;
            desktopName = "Jellyfin MPV Shim";
            categories = ["Video" "AudioVideo" "TV" "Player"];
          };
        });
      })
  ];
}
