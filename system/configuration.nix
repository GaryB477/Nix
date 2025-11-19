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
  environment.systemPackages = with pkgs; [ just ];
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
  # services.adguardhome.enable = true;
  # services.adguardhome = {
  #   enable = true;
    # settings = {
    #   http = {
    #     # You can select any ip and port, just make sure to open firewalls where needed
    #     address = "127.0.0.1:3003";
    #   };
    #   dns = {
    #     upstream_dns = [
    #       # Example config with quad9
    #       "9.9.9.9#dns.quad9.net"
    #       "149.112.112.112#dns.quad9.net"
    #       # Uncomment the following to use a local DNS service (e.g. Unbound)
    #       # Additionally replace the address & port as needed
    #       # "127.0.0.1:5335"
    #     ];
    #   };
    #   filtering = {
    #     protection_enabled = true;
    #     filtering_enabled = true;

    #     parental_enabled = false;  # Parental control-based DNS requests filtering.
    #     safe_search = {
    #       enabled = false;  # Enforcing "Safe search" option for search engines, when possible.
    #     };
    #   };
    #   # The following notation uses map
    #   # to not have to manually create {enabled = true; url = "";} for every filter
    #   # This is, however, fully optional
    #   filters = map(url: { enabled = true; url = url; }) [
    #     "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt"  # The Big List of Hacked Malware Web Sites
    #     "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt"  # malicious url blocklist
    #   ];
    # };
  # };
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
