{ config, lib, pkgs, ... }:

with lib;
{
  options.modules.dev.haskell = with types; {
    enable = mkOption {
      type = bool;
      default = false;
    };
  };

  config = mkIf config.modules.dev.haskell.enable {
    environment.systemPackages = with pkgs; [
      cabal-install
      ghc
      haskell-language-server
      haskellPackages.cabal-fmt
      haskellPackages.implicit-hie
      hlint
      ormolu
    ];
  };
}
