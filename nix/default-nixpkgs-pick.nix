let
  nixpkgs-src =
    let
      # ref "release-20.09", 30 September 2020
      commit = "663ff8739c59c492d215f3a6e65968a16a7df8a8";
    in
      fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/${commit}.tar.gz";
        sha256 = "0g2nn388cvc21ihk3w3pzglvn6hi57f5pzgiqq3fx5sl1fkvxw05";
      };
in
import nixpkgs-src {} // { inherit nixpkgs-src; }
