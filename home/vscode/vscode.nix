{ pkgs, lib, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    mutableExtensionsDir = true;
    extensions = with pkgs.vscode-marketplace; [
      # vim
      vscodevim.vim

      # nix
      jnoortheen.nix-ide

      # git
      eamodio.gitlens
      waderyan.gitblame

      # shell
      timonwong.shellcheck
      marcovr.actions-shell-scripts

      # python
      ms-python.python
      ms-python.vscode-pylance
      ms-python.debugpy
      charliermarsh.ruff

      # terraform
      hashicorp.terraform

      # helm
      tim-koehler.helm-intellisense

      # misc
      pkief.material-icon-theme
      streetsidesoftware.code-spell-checker
      github.vscode-github-actions

      # ai
      anthropic.claude-code
    ];
  };

  # Bridge: macOS VSCode reads from Library/..., stow manages ~/.config/Code/
  # Chain: Library/.../settings.json -> ~/.config/Code/User/settings.json -> dotfiles (stow)
  home.activation.vscodeStowBridge = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    target="$HOME/Library/Application Support/Code/User"
    mkdir -p "$target"
    ln -sf "$HOME/.config/Code/User/settings.json" "$target/settings.json"
    ln -sf "$HOME/.config/Code/User/keybindings.json" "$target/keybindings.json"
  '';
}
