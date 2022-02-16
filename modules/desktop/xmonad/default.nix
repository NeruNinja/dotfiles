{ config, lib, pkgs, ... }:

with lib;
{
  options.modules.desktop.xmonad = with types; {
    enable = mkOption {
      type = bool;
      default = false;
    };
  };

  config = mkIf config.modules.desktop.xmonad.enable {
    services.xserver = {
      enable = true;

      displayManager = {
        defaultSession = "none+xmonad";
        lightdm = {
          enable = true;
          greeters.mini.enable = true;
          greeters.mini.user = "neru";
        };
      };

      windowManager.xmonad = {
        enable = true;
      };
    };

    environment.systemPackages = with pkgs; [
      dmenu
      firefox
      xterm
    ];
  };
}
