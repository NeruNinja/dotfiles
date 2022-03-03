{ config, pkgs, ... }:

{
  imports = [
    ../common-configuration.nix
    ./hardware-configuration.nix
  ];

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = "experimental-features = nix-command flakes";
  };

  time.timeZone = "UTC";
  system.stateVersion = "21.11";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "shuriken";
  networking.hostId = "948e3734";
  networking.useDHCP = false;
  networking.interfaces.ens3.useDHCP = true;

  modules = {
    desktop = {
      obsidian.enable = true;
      xmonad.enable = true;
    };

    dev = {
      haskell.enable = true;
    };

    ide = {
      vscode.enable = true;
    };
  };
}
