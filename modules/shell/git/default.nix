{ config, lib, pkgs, ... }:

with lib;
{
  options.modules.shell.git = with types; {
    enable = mkOption {
      type = bool;
      default = false;
    };
  };

  config = mkIf config.modules.shell.git.enable {
    environment.systemPackages = with pkgs; [
      gitAndTools.delta
      gitAndTools.gitFull
      github-cli
    ];

    dot.files = [
      {
        link = "${config.users.users.neru.home}/.config/git/config";
        target = ./config;
      }
    ];
  };
}
