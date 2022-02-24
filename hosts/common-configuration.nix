{ config, lib, pkgs, ... }:

let
  passwordFileDirectory = "/etc/nixos/users/passwords";
  neruHashedPasswordFile = "${passwordFileDirectory}/neru";
  rootHashedPasswordFile = "${passwordFileDirectory}/root";
in
{
  imports = [
    ../modules
    ../secrets
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  users.mutableUsers = false;

  users.users.neru = {
    isNormalUser = true;
    description = "Neru Ninja";
    home = "/home/neru";
    extraGroups = [ "wheel" ];
    passwordFile = neruHashedPasswordFile;
  };

  secrets.neru-password = {
    encryptedFile = ../secrets/user-passwords/neru.asc;
    decryptionPath = neruHashedPasswordFile;
  };

  users.users.root = {
    passwordFile = rootHashedPasswordFile;
  };

  secrets.root-password = {
    encryptedFile = ../secrets/user-passwords/root.asc;
    decryptionPath = rootHashedPasswordFile;
  };
}
