let
  nixpkgs-src =
    let
      # ref "release-20.09", 14 September 2020
      commit = "5f5d8947d2583eeeba7b9e350506e15d6632af1e";
    in
      fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/${commit}.tar.gz";
        sha256 = "15ra369rhdxd747jm0ylr8sd6vpnhsqdbl7h9hr1fhnv33p49ngj";
      };
in
import nixpkgs-src {} // { inherit nixpkgs-src; }
