{ config, pkgs, inputs, ... }:

let
#   # emacsOverlaySha256 = "06413w510jmld20i4lik9b36cfafm501864yq8k4vxl5r4hn0j0h";
    user = "%USER%";
in
{
  astroNvim = {
    username = "${user}";
    nerdfont = "FiraCode";
    nodePackage = pkgs.nodejs_20;
    pythonPackage = pkgs.python3;
  };

  nixpkgs = {

    config = {
      allowUnfree = true;
      allowBroken = true;
      allowInsecure = false;
      allowUnsupportedSystem = true;
    };

    overlays =
      # Apply each overlay found in the /overlays directory
      let path = ../../overlays; in with builtins;
      map (n: import (path + ("/" + n)))
          (filter (n: match ".*\\.nix" n != null ||
                      pathExists (path + ("/" + n + "/default.nix")))
                  (attrNames (readDir path)))
      ++ [inputs.claude-code.overlays.default];
      #
      # ++ [(import (builtins.fetchTarball {
      #          url = "https://github.com/dustinlyons/emacs-overlay/archive/refs/heads/master.tar.gz";
      #          sha256 = emacsOverlaySha256;
      #      }))];
  };
}
