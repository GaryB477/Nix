{ pkgs, ... }:
{

  programs.ghostty = {
    enable = true;
    settings = {
      macos-option-as-alt = false;
      font-size = 14;
      keybind = [
        "cmd+h=goto_split:left"
        "cmd+j=goto_split:bottom"
        "cmd+k=goto_split:top"
        "cmd+l=goto_split:right"
        "cmd+e=equalize_splits"
      ];
    };
    package = if pkgs.stdenv.hostPlatform.isDarwin then null else pkgs.ghostty; # currently marked broken on Darwin
  };

}
