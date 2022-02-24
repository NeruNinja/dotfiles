{ config, lib, pkgs, ... }:

with lib;
let
  file = with types; submodule {
    options = {
      symlink = mkOption {
        type = path;
        description = ''
          A path indicating where the symbolic link should be created inside
          the home directory upon system activation.
        '';
      };

      target = mkOption {
        type = path;
        description = ''
          The path to the configuration file that will be symbolically linked
          into the home directory upon system activation.
        '';
      };
    };
  };
in
{
  options.dot = with types; {
    enable = mkOption {
      type = bool;
      default = false;
    };

    files = mkOption {
      type = listOf file;
      default = [ ];
    };
  };
}
