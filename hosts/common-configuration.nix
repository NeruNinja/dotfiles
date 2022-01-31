{ config, pkgs, ... }:

{
  users.users = {
    neru = {
      description = "Neru Ninja";
      home = "/home/neru";
      extraGroups = [ "wheel" ];
      isNormalUser = true;
    };
  };
}
