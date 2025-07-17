{ pkgs }:

with pkgs; [
  # # General packages for development and system management
  # alacritty
  # aspell
  # aspellDicts.en
  bash-completion
  bat
  btop
  coreutils
  killall
  # neofetch
  fastfetch
  openssh
  # sqlite
  wget
  zip
  xz
  just
  meson
  ninja

  # Encryption and security tools
  age
  age-plugin-yubikey
  gnupg
  libfido2
  sops

  # Cloud-related tools and SDKs
  docker
  docker-compose

  # Media-related packages
  # emacs-all-the-icons-fonts
  dejavu_fonts
  # ffmpeg
  fd
  font-awesome
  hack-font
  noto-fonts
  noto-fonts-emoji
  meslo-lgs-nf

  # Node.js development tools
  nodePackages.npm # globally install npm
  nodePackages.prettier
  nodejs

  # Text and terminal utilities
  htop
  # hunspell
  iftop
  jetbrains-mono
  jq
  ripgrep
  tree
  tmux
  unrar
  unzip
  p7zip
  zsh-powerlevel10k

  jq # A lightweight and flexible command-line JSON processor
  yq-go # yaml processer https://github.com/mikefarah/yq
  fzf # A command-line fuzzy finder
  localsend
  xsel
  yazi
  obsidian
  # microsoft-edge
  #drawio # install by homebrew, pkgs in nix is too old
  zotero
  zoxide
  vscode
  neovim
]
