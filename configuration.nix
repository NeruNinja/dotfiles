{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  time.timeZone = "UTC";
  system.stateVersion = "21.11";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "shuriken";
  networking.hostId = "948e3734";
  networking.useDHCP = false;
  networking.interfaces.ens3.useDHCP = true;
}
