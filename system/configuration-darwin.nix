{
  config,
  inputs,
  outputs,
  pkgs,
  ...
}:
{
  networking.hostName = "DG-BYOH-9364";
  networking.knownNetworkServices = [
    "Wi-Fi"
    # "USB 10/100/1000 LAN"
  ];
  ids.gids.nixbld = 350;

  # Add ability to used TouchID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;
  system = {
    primaryUser = "marc";
    keyboard.enableKeyMapping = true;
    keyboard.remapCapsLockToEscape = true;

    defaults = {
      dock = {
        autohide = true;
        static-only = true; # show only running apps
      };

      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
      };

      NSGlobalDomain = {
        "com.apple.swipescrolldirection" = true; # use natural scroll (we use MOS to invert it again for mouse)

        # key repeat: lower is faster
        InitialKeyRepeat = 15;
        KeyRepeat = 2;

        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        ApplePressAndHoldEnabled = false;
        
        # Enable Option key for special characters
        AppleKeyboardUIMode = 3;
      };
      CustomUserPreferences = {
        "com.apple.screencapture" = {
          location = "~/Desktop";
          type = "png";
        };
        "com.apple.finder" = {
          ShowExternalHardDrivesOnDesktop = false;
          ShowHardDrivesOnDesktop = true;
          ShowMountedServersOnDesktop = true;
          ShowRemovableMediaOnDesktop = true;
          _FXSortFoldersFirst = true;
          # When performing a search, search the current folder by default
          FXDefaultSearchScope = "SCcf";
        };
      };
    };
    # activationScripts.postUserActivation.text = ''
    #   # Following line should allow us to avoid a logout/login cycle
    #   /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    # '';

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 5;
  };

  users.users.marc= {
    name = "marc";
    home = "/Users/marc";
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;
}
