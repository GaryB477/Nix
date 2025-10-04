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
    inputs.agenix.darwinModules.default
    inputs.stylix.darwinModules.stylix
    ../stylix.nix
    # ./yabai/yabai.nix
    ./skhd/skhd.nix
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
  environment.systemPackages = with pkgs; [ just ];
  # Fonts
  # NOTE: managed by stylix
  fonts.packages = with pkgs; [
    ubuntu_font_family
    etBook
    nerd-fonts.droid-sans-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.symbols-only
    nerd-fonts.ubuntu
  ];

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
      "docker"
      "firefox"
      "plex"
      "gitkraken"
      "ghostty"
      "google-chrome"
      "obsidian"
      "microsoft-teams"
      "pritunl"
    ];
  };
}
