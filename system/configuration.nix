{
  config,
  inputs,
  outputs,
  pkgs,
  ...
}:
{
  nix.package = pkgs.unstable.nix;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
    # GitHub API token to avoid rate limiting when fetching flake inputs.
    # The file is NOT managed by Nix — create it manually (once, as root):
    #
    #   sudo sh -c 'echo "access-tokens = github.com=ghp_YOUR_TOKEN" > /etc/nix/access-tokens.conf'
    #   sudo chmod 600 /etc/nix/access-tokens.conf
    #
    # A fine-grained token with no permissions (read-only public repos) is enough.
    !include /etc/nix/access-tokens.conf
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
      outputs.overlays.unstable-packages
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

  system.activationScripts.timeMachineExclusions.text = ''
    echo "Setting Time Machine exclusions..."
    /usr/bin/tmutil addexclusion \
      /Users/marc/.nuget/packages \
      /Users/marc/Library/Caches \
      /Users/marc/.cache \
      /Users/marc/.colima/_lima/_disks
    /usr/bin/tmutil addexclusion -v /nix
  '';

  # Auto-upgrade: runs as root, handles flake update + darwin-rebuild
  launchd.daemons.nix-auto-upgrade = {
    serviceConfig = {
      ProgramArguments = [
        "/bin/sh"
        "-c"
        ''
          # Only run on AC power
          pmset -g ps | grep -q 'AC Power' || exit 0
          cd /Users/marc/git/private/Nix
          touch /tmp/nix-upgrade-running
          /run/current-system/sw/bin/nix flake update && /run/current-system/sw/bin/darwin-rebuild switch --flake .#DG-BYOH-9364-dark
          echo $? > /tmp/nix-upgrade-exit-code
          rm -f /tmp/nix-upgrade-running
          touch /tmp/nix-upgrade-done
        ''
      ];
      StartCalendarInterval = [ { Hour = 3; Minute = 0; } ];
      StandardOutPath = "/var/log/nix-auto-upgrade.log";
      StandardErrorPath = "/var/log/nix-auto-upgrade.err.log";
      RunAtLoad = false;
    };
  };

  # Auto-upgrade: runs as marc, waits for daemon and runs home-manager + sends notification
  launchd.agents.nix-auto-upgrade-hm = {
    serviceConfig = {
      ProgramArguments = [
        "/bin/sh"
        "-c"
        ''
          # Wait for daemon to finish (max 2h)
          waited=0
          while [ -f /tmp/nix-upgrade-running ] && [ $waited -lt 7200 ]; do
            sleep 10
            waited=$((waited + 10))
          done

          [ -f /tmp/nix-upgrade-done ] || exit 0
          rm -f /tmp/nix-upgrade-done

          exit_code=$(cat /tmp/nix-upgrade-exit-code 2>/dev/null || echo "1")
          rm -f /tmp/nix-upgrade-exit-code

          if [ "$exit_code" != "0" ]; then
            osascript -e 'display notification "darwin-rebuild fehlgschlage. Check /var/log/nix-auto-upgrade.log" with title "Nix Auto-Upgrade" subtitle "Fehler"'
            exit 1
          fi

          cd /Users/marc/git/private/Nix
          /Users/marc/.nix-profile/bin/home-manager switch --flake .#DG-BYOH-9364-dark
          hm_exit=$?

          if [ $hm_exit -eq 0 ]; then
            osascript -e 'display notification "System und Home Manager erfolgreich upgraded" with title "Nix Auto-Upgrade" subtitle "Erfolg"'
          else
            osascript -e 'display notification "home-manager fehlgschlage. Check ~/.local/log/nix-hm-upgrade.log" with title "Nix Auto-Upgrade" subtitle "Fehler"'
          fi
        ''
      ];
      StartCalendarInterval = [ { Hour = 3; Minute = 10; } ];
      StandardOutPath = "/Users/marc/.local/log/nix-hm-upgrade.log";
      StandardErrorPath = "/Users/marc/.local/log/nix-hm-upgrade.err.log";
      RunAtLoad = false;
    };
  };
  # some GUI apps need to be installed with homebrew (but not all!)
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };
    taps = builtins.attrNames config.nix-homebrew.taps;
    brews = [
      "openapi-generator"
    ];
    casks = [
      "1password"
      "balenaetcher"
      "eurkey" # keyboard layout
      "docker"
      "plex"
      "krisp"
      "freelens"
      "gitkraken"
      "ghostty"
      "hammerspoon"
      "obsidian"
      "microsoft-teams"
      "pritunl"
      "easy-move+resize" # Click and drag windows
      "lm-studio"
    ];
  };
}
