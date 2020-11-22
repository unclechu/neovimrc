# Need newer fzf for newer fzf plugin.
# At this moment fzf was too old for newer plugin version to work.
# TODO Get rid of this pick when “release-20.09” get newer “fzf”
let
  nixpkgs-src =
    let
      # ref “nixpkgs-unstable”, 18 November 2020
      commit = "6625284c397b44bc9518a5a1567c1b5aae455c08";
    in
      fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/${commit}.tar.gz";
        sha256 = "1w0czzv53sg35gp7sr506facbmzd33jm34p6cg23fb9kz5rf5c89";
      };

  nixpkgs = import nixpkgs-src {};
in
  nixpkgs.fzf // { inherit nixpkgs-src nixpkgs; }
