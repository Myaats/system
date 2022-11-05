{...}: {
  imports = [
    ./mats.nix
  ];

  # Needed for some group things
  users.users.root.extraGroups = ["wheel"];
}
