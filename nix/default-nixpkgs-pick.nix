let
  nixpkgs-src =
    let
      # ref “release-20.09”, 6 October 2020
      commit = "e350a3327e5604a81752581fb81c91475bf4c29a";
    in
      fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/${commit}.tar.gz";
        sha256 = "0jlfnnpsic9f92k8h5bq8ykk1g3shgny6f5d6q7xrs670gp5ni3k";
      };
in
import nixpkgs-src {} // { inherit nixpkgs-src; }
