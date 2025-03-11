{lib, ...}: let
  inherit (lib) types;
in {
  options.users.primaryUser = {
    username = lib.mkOption {
      type = types.str;
    };
    fullName = lib.mkOption {
      type = types.str;
    };
    email = lib.mkOption {
      type = types.str;
    };
    nixConfigDirectory = lib.mkOption {
      type = types.str;
    };
  };
}
