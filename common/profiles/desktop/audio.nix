{pkgs, ...}: {
  # Add volume control (pulse)
  environment.systemPackages = with pkgs; [
    pavucontrol
  ];

  # Force disable pulseaudio
  hardware.pulseaudio.enable = false;

  # Enable rtkit for pipewire
  security.rtkit.enable = true;

  # Enable pipewire
  services.pipewire = {
    enable = true;
    # Enable alsa, pulse and jack compat
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
}
