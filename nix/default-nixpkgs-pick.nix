let
  nixpkgs-src =
    let
      # ref “release-20.09”, 2 November 2020
      commit = "faee35ae82cc54bff6e5235895d4968f0de8d39a";
    in
      fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/${commit}.tar.gz";
        sha256 = "0jgp6czvqxh30hnq1a3l24mahcmqh6ik729jw1vq13pllhbb2p4b";
      };
in
import nixpkgs-src {} // { inherit nixpkgs-src; }
