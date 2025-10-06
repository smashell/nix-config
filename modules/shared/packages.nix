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
  # meson
  # ninja
  glow
  ansible

  # Encryption and security tools
  age
  age-plugin-yubikey
  gnupg
  libfido2
  # sops

  # Cloud-related tools and SDKs
  docker
  docker-compose
  lazydocker

  # Media-related packages
  # emacs-all-the-icons-fonts
  dejavu_fonts
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/data/fonts/nerd-fonts/manifests/fonts.json
  nerd-fonts."ubuntu-mono"
  nerd-fonts."fira-code"
  nerd-fonts."fira-mono"
  # ffmpeg
  fd
  font-awesome
  hack-font
  noto-fonts
  noto-fonts-emoji
  meslo-lgs-nf

  # # Node.js development tools
  # nodePackages.npm # globally install npm
  # nodePackages.prettier
  # nodejs
  uv

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
  # exa
  duf
  difftastic

  jq # A lightweight and flexible command-line JSON processor
  yq-go # yaml processer https://github.com/mikefarah/yq
  fzf # A command-line fuzzy finder
  localsend
  xsel
  yazi
  yaziPlugins.rich-preview # Rich preview for Yazi
  # rich-cli            # Rich command-line interface for rich preview
  obsidian
  # microsoft-edge
  #drawio # install by homebrew, pkgs in nix is too old
  zotero
  zoxide
  vscode
  neovim
]
