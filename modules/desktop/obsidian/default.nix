{ config, lib, pkgs, ... }:

with lib;
{
  options.modules.desktop.obsidian = with types; {
    enable = mkOption {
      type = bool;
      default = false;
    };
  };

  config = mkIf config.modules.desktop.obsidian.enable {
    environment.systemPackages = with pkgs; [
      obsidian
    ];
  };
}
