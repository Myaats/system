{...}: {
  # Use English English as locale
  i18n.defaultLocale = "en_GB.UTF-8";

  # Use Oslo as timezone
  time.timeZone = "Europe/Oslo";

  # Use no as default keyboard layout, and make console use it too
  services.xserver.layout = "no";
  console.useXkbConfig = true;
}
