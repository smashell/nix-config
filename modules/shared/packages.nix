{ pkgs }:

with pkgs;
let
  iflow-cli = pkgs.stdenv.mkDerivation rec {
    pname = "iflow-cli";
    version = "0.3.24";

    src = pkgs.fetchurl {
      url = "https://registry.npmjs.org/@iflow-ai/iflow-cli/-/iflow-cli-${version}.tgz";
      sha256 = "sha256-5qhYD3pTBXi2U39ZrssDG29kRfXSPnyxOqga3o33vZM=";
    };

    buildInputs = [ pkgs.nodejs ];

    installPhase = ''
      mkdir -p $out/lib/node_modules/@iflow-ai/iflow-cli
      cp -r . $out/lib/node_modules/@iflow-ai/iflow-cli/
      mkdir -p $out/bin
      ln -s $out/lib/node_modules/@iflow-ai/iflow-cli/bundle/iflow.js $out/bin/iflow
      chmod +x $out/lib/node_modules/@iflow-ai/iflow-cli/bundle/iflow.js
    '';

    meta = with pkgs.lib; {
      description = "iFlow AI CLI tool";
      homepage = "https://iflow.ai";
      mainProgram = "iflow";
    };
  };
in
[
  # System & Terminal Utilities
  bash-completion
  bat
  coreutils
  killall
  wget
  zip
  xz
  unzip
  p7zip
  unrar
  openssh
  fd
  fzf
  zoxide
  just
  tree
  htop
  btop
  iftop
  duf

  # Development & Data Processing
  glow
  jq
  yq-go # yaml processer https://github.com/mikefarah/yq
  difftastic
  ansible
  uv

  # Container & Cloud Native
  docker
  docker-compose
  lazydocker

  # Security & Cryptography
  age
  age-plugin-yubikey
  gnupg
  libfido2

  # Fonts & UI Appearance
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/data/fonts/nerd-fonts/manifests/fonts.json
  nerd-fonts."jetbrains-mono"
  nerd-fonts."fira-code"
  nerd-fonts."fira-mono"
  zsh-powerlevel10k
  # dejavu_fonts
  # font-awesome
  # hack-font
  # noto-fonts
  # noto-fonts-emoji
  # meslo-lgs-nf
  # jetbrains-mono

  # Apps
  tmux
  vscode
  neovim
  yazi
  yaziPlugins.rich-preview
  # rich-cli            # Rich command-line interface for rich preview
  obsidian
  zotero
  localsend
  
  # Custom packages
  iflow-cli

]
