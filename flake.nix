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

    # This flake output allows for ad-hoc syncing of dotfiles for quickly
    # testing out new user configuration without requiring a rebuild of the
    # NixOS system: `nix eval --json .#dotfiles | dot link`
    dotfiles = self.nixosConfigurations.shuriken.config.dot.files;
  };
}
