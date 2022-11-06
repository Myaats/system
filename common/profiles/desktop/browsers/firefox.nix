{
  pkgs,
  nur,
  lib,
  ...
}:
with lib; {
  home-manager.config = {
    programs.firefox = {
      enable = true;
      profiles.mats = {
        settings = {
          "browser.search.region" = "NO";
          # Theme
          "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
          "devtools.theme" = "dark";
          #"browser.proton.enabled" = false; # Kill proton # Broken by the newest update :(
          # Extensions
          "extensions.autoDisableScopes" = 0; # Auto enable addons
          # Disable stuff I never use or want to use
          "browser.messaging-system.whatsNewPanel.enabled" = false;
          "extensions.pocket.enabled" = false;
          "identity.fxaccounts.enabled" = true;
          "identity.fxaccounts.pairing.enabled" = true;
          "identity.fxaccounts.toolbar.enabled" = true;
          "identity.fxaccounts.commands.enabled" = true;
          "signon.management.page.breach-alerts.enabled" = false;
          "services.sync.engine.passwords" = false;
          "browser.feeds.showFirstRunUI" = false;
          "app.shield.optoutstudies.enabled" = false;
          "browser.discovery.enabled" = false;
          "general.warnOnAboutConfig" = false;
          # Newtab
          "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
          "browser.newtabpage.activity-stream.feeds.snippets" = false;
          "browser.newtabpage.activity-stream.feeds.topsites" = false;
          "browser.newtabpage.activity-stream.prerender" = false;
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
          "browser.newtabpage.enhanced" = true;
          # Make .lan resolve using DNS instead of search
          "browser.fixup.domainsuffixwhitelist.lan" = true;

          # Begone telemetry
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.archive.enabled" = false;
          "browser.newtabpage.activity-stream.telemetry" = false;
          "datareporting.healthreport.uploadEnabled" = false;
        };
      };

      extensions = with nur.repos.rycee.firefox-addons; [
        stylus
        multi-account-containers
        ublock-origin
      ];
    };

    systemd.user.sessionVariables = {MOZ_ENABLE_WAYLAND = 1;};
  };
}
