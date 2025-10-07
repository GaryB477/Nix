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
      };
      oh-my-zsh = { # "ohMyZsh" without Home Manager
        enable = true;
        plugins = [ "git" ];
        theme = "robbyrussell";
      };
      history.size = 10000;
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