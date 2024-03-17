{pkgs, ...}: {
  environment.systemPackages = with pkgs; [vim alejandra terminal-notifier];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = ["nix-command" "flakes" "repl-flake"];
  nix.settings.trusted-users = ["root" "berryp" "@admin"];
  nix.settings.extra-nix-path = "nixpkgs=flake:nixpkgs";

  nix.extraOptions = ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  users.users.berryp = {
    name = "berryp";
    home = "/Users/berryp";
  };

  nixpkgs.hostPlatform = "aarch64-darwin";

  system.stateVersion = 4;
  security.pam.enableSudoTouchIdAuth = true;

  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    fira
    (nerdfonts.override {fonts = ["FiraCode"];})
  ];

  #### DEFAULTS ####

  # https://macos-defaults.com/
  # https://defaults-write.com
  # https://github.com/LnL7/nix-darwin/blob/master/modules/system/defaults
  system.defaults.NSGlobalDomain = {
    "com.apple.trackpad.scaling" = 3.0;
    AppleInterfaceStyle = "Dark";
    AppleInterfaceStyleSwitchesAutomatically = false;
    AppleMeasurementUnits = "Centimeters";
    AppleMetricUnits = 1;
    AppleShowScrollBars = "Automatic";
    AppleTemperatureUnit = "Celsius";
    AppleKeyboardUIMode = 3; # full control
    InitialKeyRepeat = 15;
    KeyRepeat = 2;
    NSAutomaticCapitalizationEnabled = false;
    NSAutomaticDashSubstitutionEnabled = false;
    NSAutomaticPeriodSubstitutionEnabled = false;
    _HIHideMenuBar = false;
  };

  # Firewall
  system.defaults.alf = {
    globalstate = 1;
    allowsignedenabled = 1;
    allowdownloadsignedenabled = 1;
    stealthenabled = 1;
  };

  # Dock and Mission Control
  system.defaults.dock = {
    autohide = true;
    expose-group-by-app = false;
    mru-spaces = false;
    tilesize = 36;
    show-recents = false;
    mineffect = "scale";
    # Disable all hot corners
    wvous-bl-corner = 1;
    wvous-br-corner = 1;
    wvous-tl-corner = 1;
    wvous-tr-corner = 1;
  };

  # Login and lock screen
  system.defaults.loginwindow = {
    GuestEnabled = false;
    DisableConsoleAccess = true;
  };

  # Spaces
  system.defaults.spaces.spans-displays = false;

  # Trackpad
  system.defaults.trackpad = {
    Clicking = true;
    # Scaling = 1.5;
    TrackpadRightClick = true;
  };

  # Finder
  system.defaults.finder = {
    FXEnableExtensionChangeWarning = false;
    FXPreferredViewStyle = "Nlsv"; # list viw
    FXDefaultSearchScope = "SCcf"; # current folder
    ShowPathbar = true;
  };

  system.defaults.SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;

  #   mods = {
  #     none = 0;
  #     shift = 131072;
  #     control = 262144;
  #     option = 524288;
  #     command = 1048576;
  #     shiftControl = 393216;
  #     shiftOption = 655360;
  #     shiftCommand = 1179648;
  #     controlOption = 786432;
  #     controlCommand = 1310720;
  #     optionCommand = ≈;
  #     shiftControlOption = 917504;
  #     shiftControlCommand = 1441792;
  #     shiftOptionCommand = 1703936;
  #     ControlOptionCommand = 1835008;
  #     ShiftControlOptionCommand = 1966080;
  #   };

  system.activationScripts.postActivation.text = ''
    # map spotlight to ALT+SPC
    defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 64 "
    <dict>
      <key>enabled</key><true/>
      <key>value</key><dict>
        <key>type</key><string>standard</string>
        <key>parameters</key>
        <array>
          <integer>32</integer>
          <integer>49</integer>
          <integer>524288</integer>
        </array>
      </dict>
    </dict>
    "

    defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 60 "
    <dict>
      <key>enabled</key><false/>
      <key>value</key><dict>
        <key>type</key><string>standard</string>
        <key>parameters</key>
        <array>
          <integer>32</integer>
          <integer>49</integer>
          <integer>262144</integer>
        </array>
      </dict>
    </dict>
    "

    defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 61 "
    <dict>
      <key>enabled</key><true/>
      <key>value</key><dict>
        <key>type</key><string>standard</string>
        <key>parameters</key>
        <array>
          <integer>32</integer>
          <integer>49</integer>
          <integer>1572864</integer>
        </array>
      </dict>
    </dict>
    "

    # defaults write com.raycast.macos raycastGlobalHotkey -string Command-49
    # defaults write com.raycast.macos raycastPreferredWindowMode compact
    # defaults write com.raycast.macos showGettingStartedLink 0
    # defaults write com.apple.dock workspaces-swoosh-animation-off -bool YES

    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';

  system.defaults.CustomUserPreferences = {
    "com.raycast.macos" = {
      "com.raycast.macos.raycastGlobalHotkey" = "Command-49";
      "com.raycast.macos.raycastPreferredWindowMode" = "compact";
      "com.raycast.macos.showGettingStartedLink" = 0;
    };
  };

  system.defaults.CustomSystemPreferences = {};

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
    userKeyMapping = [
      {
        HIDKeyboardModifierMappingSrc = 30064771172;
        HIDKeyboardModifierMappingDst = 30064771125;
      }
    ];
  };
}
