{ pkgs, config, ... }:

# let
#  githubPublicKey = "ssh-ed25519 AAAA...";
# in
{
  ".bin" = {
    source = ./bin; 
    # target = "dir"; 
  };
  # ".bin/libreoffice" = {
  #   executable = true;
  #   text = ''
  #     #!/bin/sh
  #     exec "/Applications/LibreOffice.app/Contents/MacOS/soffice" "$@"
  #   '';
  # };

  # ".ssh/id_github.pub" = {
  #   text = githubPublicKey;
  # };

  # # Initializes Emacs with org-mode so we can tangle the main config
  # ".emacs.d/init.el" = {
  #   text = builtins.readFile ../shared/config/emacs/init.el;
  # };
}
