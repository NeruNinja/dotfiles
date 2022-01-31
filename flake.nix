{
  description = "@NeruNinja's dotfiles";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations = {
      shuriken = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/shuriken/configuration.nix ];
      };
    };
  };
}
