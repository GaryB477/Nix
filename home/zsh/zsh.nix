{ pkgs, ... }:
  {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        ll = "ls -l";
        lg = "lazygit";
        t = "tree -L 2";
        cp = "rsync -ah --progress";
        gs = "git status";
        gc = "git clone ";
        prc = "gh pr create -d --fill && gh pr view --web";
        prv = "gh pr view --web";
      };
      oh-my-zsh = { # "ohMyZsh" without Home Manager
        enable = true;
        plugins = [ "git" ];
        theme = "robbyrussell";
      };
      initExtra = ''
        # Disable ctrl+h keybinding
        bindkey -r "^H"
      '';
      history.size = 10000;
    };

    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;  # Optional but recommended for Nix projects
    };

    # Enable fzf with zsh integration
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      # Optional: customize fzf options
      defaultOptions = [
        "--height 40%"
        "--layout=reverse"
        "--border"
        "--inline-info"
      ];
    };
  }
