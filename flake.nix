# Bootstrap:
# nix --extra-experimental-features "nix-command flakes" run nix-darwin -- --flake github:berryp/nix-darwin#`hostname`
# Update:
# nix flake update && darwin-rebuild switch --flake .
# Optional: nix flake update --commit-lock-file
{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    self,
    nix-darwin,
    nixpkgs,
  }: let
    configuration = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        vim
        alejandra
        terminal-notifier
      ];

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings = {
        experimental-features = ["nix-command" "flakes" "repl-flake"];
        trusted-users = ["root" "berryp" "@admin"];
        extra-nix-path = "nixpkgs=flake:nixpkgs";
      };

      nix.extraOptions = ''
        extra-platforms = x86_64-darwin aarch64-darwin
      '';

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true; # default shell on catalina
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      # Unlock sudo via fingerprint
      security.pam.enableSudoTouchIdAuth = true;

      # fonts.fontDir.enable = true;
      # fonts.fonts = with pkgs; [
      #   fira
      #   (nerdfonts.override {fonts = ["FiraCode"];})
      # ];

      # system.defaults = {
      #   NSGlobalDomain = {
      #     "com.apple.trackpad.scaling" = 3.0;
      #     AppleInterfaceStyle = "Dark";
      #     AppleInterfaceStyleSwitchesAutomatically = false;
      #     AppleMeasurementUnits = "Centimeters";
      #     AppleMetricUnits = 1;
      #     AppleShowScrollBars = "Automatic";
      #     AppleTemperatureUnit = "Celsius";
      #     AppleKeyboardUIMode = 3; # full control
      #     InitialKeyRepeat = 15;
      #     KeyRepeat = 2;
      #     NSAutomaticCapitalizationEnabled = false;
      #     NSAutomaticDashSubstitutionEnabled = false;
      #     NSAutomaticPeriodSubstitutionEnabled = false;
      #     _HIHideMenuBar = false;
      #   };

      #   # Firewall
      #   alf = {
      #     globalstate = 1;
      #     allowsignedenabled = 1;
      #     allowdownloadsignedenabled = 1;
      #     stealthenabled = 1;
      #   };

      #   # Dock and Mission Control
      #   dock = {
      #     autohide = true;
      #     expose-group-by-app = false;
      #     mru-spaces = false;
      #     tilesize = 36;
      #     show-recents = false;
      #     mineffect = "scale";
      #     # Disable all hot corners
      #     wvous-bl-corner = 1;
      #     wvous-br-corner = 1;
      #     wvous-tl-corner = 1;
      #     wvous-tr-corner = 1;
      #   };

      #   # Login and lock screen
      #   loginwindow = {
      #     GuestEnabled = false;
      #     DisableConsoleAccess = true;
      #   };

      #   # Spaces
      #   spaces.spans-displays = false;

      #   # Trackpad
      #   trackpad = {
      #     Clicking = true;
      #     # Scaling = 1.5;
      #     TrackpadRightClick = true;
      #   };

      #   # Finder
      #   finder = {
      #     FXEnableExtensionChangeWarning = false;
      #     FXPreferredViewStyle = "Nlsv"; # list viw
      #     FXDefaultSearchScope = "SCcf"; # current folder
      #     ShowPathbar = true;
      #   };

      #   SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;

      #   #   mods = {
      #   #     none = 0;
      #   #     shift = 131072;
      #   #     control = 262144;
      #   #     option = 524288;
      #   #     command = 1048576;
      #   #     shiftControl = 393216;
      #   #     shiftOption = 655360;
      #   #     shiftCommand = 1179648;
      #   #     controlOption = 786432;
      #   #     controlCommand = 1310720;
      #   #     optionCommand = ≈;
      #   #     shiftControlOption = 917504;
      #   #     shiftControlCommand = 1441792;
      #   #     shiftOptionCommand = 1703936;
      #   #     ControlOptionCommand = 1835008;
      #   #     ShiftControlOptionCommand = 1966080;
      #   #   };

      #   system.activationScripts.postActivation.text = ''
      #     # map spotlight to ALT+SPC
      #     defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 64 "
      #     <dict>
      #       <key>enabled</key><true/>
      #       <key>value</key><dict>
      #         <key>type</key><string>standard</string>
      #         <key>parameters</key>
      #         <array>
      #           <integer>32</integer>
      #           <integer>49</integer>
      #           <integer>524288</integer>
      #         </array>
      #       </dict>
      #     </dict>
      #     "

      #     defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 60 "
      #     <dict>
      #       <key>enabled</key><false/>
      #       <key>value</key><dict>
      #         <key>type</key><string>standard</string>
      #         <key>parameters</key>
      #         <array>
      #           <integer>32</integer>
      #           <integer>49</integer>
      #           <integer>262144</integer>
      #         </array>
      #       </dict>
      #     </dict>
      #     "

      #     defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 61 "
      #     <dict>
      #       <key>enabled</key><true/>
      #       <key>value</key><dict>
      #         <key>type</key><string>standard</string>
      #         <key>parameters</key>
      #         <array>
      #           <integer>32</integer>
      #           <integer>49</integer>
      #           <integer>1572864</integer>
      #         </array>
      #       </dict>
      #     </dict>
      #     "

      #     # defaults write com.raycast.macos raycastGlobalHotkey -string Command-49
      #     # defaults write com.raycast.macos raycastPreferredWindowMode compact
      #     # defaults write com.raycast.macos showGettingStartedLink 0
      #     # defaults write com.apple.dock workspaces-swoosh-animation-off -bool YES

      #     /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
      #   '';

      #   CustomUserPreferences = {
      #     "com.raycast.macos" = {
      #       "com.raycast.macos.raycastGlobalHotkey" = "Command-49";
      #       "com.raycast.macos.raycastPreferredWindowMode" = "compact";
      #       "com.raycast.macos.showGettingStartedLink" = 0;
      #     };
      #   };

      #   CustomSystemPreferences = {};

      #   system.keyboard = {
      #     enableKeyMapping = true;
      #     remapCapsLockToEscape = true;
      #     userKeyMapping = [
      #       {
      #         HIDKeyboardModifierMappingSrc = 30064771172;
      #         HIDKeyboardModifierMappingDst = 30064771125;
      #       }
      #     ];
      #   };
      # };
    };
  in {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."Berrys-Mac-mini" = nix-darwin.lib.darwinSystem {
      modules = [configuration];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."Berrys-Mac-mini".pkgs;
  };
}
