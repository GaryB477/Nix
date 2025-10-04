host := `hostname`

default:
    @just --list

# rebuild NixOS configuration and switch. mode = 'dark' or 'light'
[linux]
nixos-switch mode='dark':
    sudo nix run .#rebuild-{{ host }}-{{ mode }}

# rebuild nix darwin configuration and switch. mode = 'dark' or 'light'
[macos]
nix-darwin-switch mode='dark':
    sudo nix run .#rebuild-{{ host }}-{{ mode }}

[macos]
nix-rebuild:
    sudo nix run --extra-experimental-features "nix-command flakes" .#rebuild-$(hostname)-dark --show-trace && \
    home-manager switch --flake .#DG-BYOH-9364-dark

# rebuild Home Manager config and switch. mode = 'dark' or 'light'
[unix]
hm-switch mode='dark':
    nix run .#hm-switch-{{ host }}-{{ mode }}

# format all sources in the repository
format:
    nix fmt

check:
    nix flake check --impure

update:
    nix flake update && rebuild && hm-switch

# clean up nix store by removing old generations etc.
[unix]
collect-garbage:
    nix-collect-garbage -d
