let
  nixpkgs-src =
    let
      # ref “release-20.09”, 21 November 2020
      commit = "7bf4729c5b940b1e2efd308606f35a27fc436be3";
    in
      fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/${commit}.tar.gz";
        sha256 = "1f1qbadjdjq19pz6a4nysv9q579hzh1yc8ncad6y1dsi0lbf8aq0";
      };
in
import nixpkgs-src {} // { inherit nixpkgs-src; }
