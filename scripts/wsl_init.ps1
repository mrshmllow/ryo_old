Invoke-WebRequest https://github.com/nix-community/NixOS-WSL/releases/latest/download/nixos-wsl.tar.gz -OutFile nixos-wsl.tar.gz

wsl --import NixOS_Testing .\NixOS_Testing\ nixos-wsl.tar.gz --version 2

wsl -d NixOS_Testing --user nixos --shell-type login -- sudo nix-channel --update

wsl -d NixOS_Testing --user nixos --shell-type login -- sudo rm -rf /etc/nixos
wsl -d NixOS_Testing --user nixos --shell-type login -- sudo nix-shell -p git --run "git clone https://github.com/mrshmllow/ryo /etc/nixos"
wsl -d NixOS_Testing --user nixos --shell-type login -- sudo nix-shell -p git --run "cd /etc/nixos/ && nix --extra-experimental-features nix-command --extra-experimental-features flakes flake update && sudo nixos-rebuild switch --flake .#marsh-wsl"

wsl -d NixOS_Testing --user marsh --shell-type login -- mkdir -p ~/etc/nixos
wsl -d NixOS_Testing --user marsh --shell-type login -- git clone https://github.com/mrshmllow/ryo ~/etc/nixos
wsl -d NixOS_Testing --user marsh --shell-type login -- sudo ln -s ~/etc/nixos/ /etc/nixos
