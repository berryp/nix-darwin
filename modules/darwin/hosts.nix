{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.networking;
  localhostMultiple = any (elem "localhost") (attrValues (removeAttrs cfg.hosts ["127.0.0.1" "::1"]));
in {
  options.networking.hosts = lib.mkOption {
    type = types.attrsOf (types.listOf types.str);
    example = literalExpression ''
      {
        "127.0.0.1" = [ "foo.bar.baz" ];
        "192.168.0.2" = [ "fileserver.local" "nameserver.local" ];
      };
    '';
    description = ''
      Locally defined maps of hostnames to IP addresses.
    '';
    default = {};
  };

  options.networking.hostFiles = lib.mkOption {
    type = types.listOf types.path;
    defaultText = literalMD "Hosts from {option}`networking.hosts` and {option}`networking.extraHosts`";
    example = literalExpression ''[ "''${pkgs.my-blocklist-package}/share/my-blocklist/hosts" ]'';
    description = ''
      Files that should be concatenated together to form {file}`/etc/hosts`.
    '';
  };
  options.networking.extraHosts = lib.mkOption {
    type = types.lines;
    default = "";
    example = "192.168.0.1 lanlocalhost";
    description = ''
      Additional verbatim entries to be appended to {file}`/etc/hosts`.
      For adding hosts from derivation results, use {option}`networking.hostFiles` instead.
    '';
  };

  config = {
    assertions = [
      {
        assertion = !localhostMultiple;
        message = ''
          `networking.hosts` maps "localhost" to something other than "127.0.0.1"
          or "::1". This will break some applications. Please use
          `networking.extraHosts` if you really want to add such a mapping.
        '';
      }
    ];

    networking.hostFiles = let
      # Note: localhostHosts has to appear first in /etc/hosts so that 127.0.0.1
      # resolves back to "localhost" (as some applications assume) instead of
      # the FQDN!
      localhostHosts = pkgs.writeText "localhost-hosts" ''
        ##
        # Host Database
        #
        # localhost is used to configure the loopback interface
        # when the system is booting.  Do not change this entry.
        ##
        127.0.0.1	localhost
        255.255.255.255	broadcasthost
        ::1             localhost
      '';
      stringHosts = let
        oneToString = set: ip: ip + " " + concatStringsSep " " set.${ip} + "\n";
        allToString = set: concatMapStrings (oneToString set) (attrNames set);
      in
        pkgs.writeText "string-hosts" (allToString (filterAttrs (_: v: v != []) cfg.hosts));
      extraHosts = pkgs.writeText "extra-hosts" cfg.extraHosts;
    in
      mkBefore [localhostHosts stringHosts extraHosts];

    environment.etc.hosts = {
      knownSha256Hashes = [
        "c7dd0e2ed261ce76d76f852596c5b54026b9a894fa481381ffd399b556c0e2da"
      ];

      source = pkgs.concatText "hosts" cfg.hostFiles;
    };
  };
}
