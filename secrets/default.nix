{ config, lib, pkgs, ... }:

let
  secret = with lib.types; submodule {
    options = {
      encryptedFile = lib.mkOption {
        type = path;
        description = ''
          A file that contains secret data. The file should be an ASCII-armor
          encrypted since files tracked in version control systems are copied
          to the Nix store (which is world-readable) when a flake is evaluated.
          Upon system activation, the file will be decrypted and written to the
          decryption path. Ensure that the recipient of the file exists in the
          keyring of the root user.
        '';
      };

      decryptionPath = lib.mkOption {
        type = path;
        description = ''
          A path representing the target location where the decrypted secret
          will be copied to during system activation.
        '';
      };

      owner = lib.mkOption {
        type = str;
        default = "root";
        description = ''
          The name of the Unix user that will own the decrypted file.
        '';
      };

      group = lib.mkOption {
        type = str;
        default = "root";
        description = ''
          The name of the group that will own the decrypted file.
        '';
      };

      permissions = lib.mkOption {
        type = str;
        default = "0400";
        description = ''
          The permission flags of the decrypted secret expressed as a chmod
          mode argument (i.e. an octal number like "0400" or a symbolic mode
          like "u+x"). Consult the chmod(1) man page.
        '';
      };
    };
  };

  mkDecryptionService = name:
    { encryptedFile, decryptionPath, owner, group, permissions }: {
      description = "Decrypt secrets for ${name}";
      wantedBy = [ "multi-user.target" ];
      serviceConfig.Type = "oneshot";
      script = with pkgs; ''
        rm -rf ${decryptionPath}
        mkdir -p $(dirname ${decryptionPath})
        ${gnupg}/bin/gpg --decrypt ${encryptedFile} > ${decryptionPath}
        chown ${owner}:${group} ${decryptionPath}
        chmod ${permissions} ${decryptionPath}
      '';
    };
in
{
  options.secrets = with lib.types; lib.mkOption {
    type = attrsOf secret;
    default = { };
    description = "Secrets";
  };

  config.systemd.services = lib.mapAttrs'
    (name: info: {
      name = "${name}-secret";
      value = (mkDecryptionService name info);
    })
    config.secrets;
}
