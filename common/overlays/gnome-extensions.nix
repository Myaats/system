{...}: {
  nixpkgs.overlays = [
    (self: super:
      with super; {
        gnomeExtensions = with gnomeExtensions;
          gnomeExtensions
          // {
            # Use WIP gnome_43_rewrite branch
            improved-osk = improved-osk.overrideAttrs (oldAttrs: {
              src = fetchFromGitHub {
                owner = "nick-shmyrev";
                repo = "improved-osk-gnome-ext";
                rev = "4b90813b22abcfc6ec07e7aa1a8270f8a8fda0f8";
                sha256 = "sha256-sNnF3YjEq/5rTDTJLM3hlQiGppyn21jEz7l+e56ez8E=";
              };

              postPatch = ''
                substituteInPlace "extension.js" \
                  --replace "(GLib.getenv('JHBUILD_PREFIX') || '/usr')" "\"\"" \
                  --replace "/share/gnome-shell/gnome-shell-osk-layouts.gresource" "${placeholder "out"}/share/gnome-shell/extensions/improvedosk@nick-shmyrev.dev/data/gnome-shell-osk-layouts.gresource"
              '';
            });
          };
      })
  ];
}
