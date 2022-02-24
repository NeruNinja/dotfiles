{ config, lib, pkgs, ... }:

with lib;
{
  options.modules.ide.vscode = with types; {
    enable = mkOption {
      type = bool;
      default = false;
    };
  };

  config = mkIf config.modules.ide.vscode.enable {
    environment.systemPackages = with pkgs; [
      vscode
    ];
  };
}
