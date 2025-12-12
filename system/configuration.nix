{
  config,
  inputs,
  outputs,
  pkgs,
  ...
}:
{
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  imports = [
    # inputs.agenix.darwinModules.default
    inputs.stylix.darwinModules.stylix
    ../stylix.nix
    # ./yabai/yabai.nix
    # ./skhd/skhd.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.modifications
      outputs.overlays.stable-packages
    ];
    # Configure your nixpkgs instance
    config = {
      # Allow unfree packages
      allowUnfree = true;
      allowUnsupportedSystem = true;
    };
  };

  # `home-manager` currently has issues adding them to `~/Applications`
  # Issue: https://github.com/nix-community/home-manager/issues/1341
  environment.systemPackages = with pkgs; [
    just
    adguardhome
  ];
  
  # go to http://127.0.0.1:3003 to access AdGuard Home UI
  # Then, add "127.0.0.1" to the DNS
  launchd.daemons.adguardhome = {
    serviceConfig = {
      ProgramArguments = [
        "${pkgs.adguardhome}/bin/adguardhome"
        "-w"
        "/Users/marc/.config/adguardhome"
        "-p"
        "3003"
      ];
      KeepAlive = true;
      RunAtLoad = true;
      StandardOutPath = "/var/log/adguardhome.out.log";
      StandardErrorPath = "/var/log/adguardhome.err.log";
    };
  };

  # Fonts
  # NOTE: managed by stylix
  fonts.packages = with pkgs; [
    ubuntu-classic
    etBook
    nerd-fonts.droid-sans-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.symbols-only
    nerd-fonts.ubuntu
  ];
  services.tailscale.enable = true;
  # some GUI apps need to be installed with homebrew (but not all!)
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };
    taps = builtins.attrNames config.nix-homebrew.taps;
    casks = [
      "1password"
      "balenaetcher"
      "docker"
      "firefox"
      "plex"
      "krisp"
      "gitkraken"
      "ghostty"
      "google-chrome"
      "hammerspoon"
      "obsidian"
      "microsoft-teams"
      "pritunl"
      "easy-move+resize" # Click and drag windows
    ];
  };
}
