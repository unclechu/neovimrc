{ pkgs   ? import ../default-nixpkgs-pick.nix
, origin ? ../../apps/git-grep-nvr.sh
}:
let
  utils = import ../utils.nix { inherit pkgs; };
  inherit (utils) esc nameOfModuleFile writeCheckedExecutable;

  name = nameOfModuleFile (builtins.unsafeGetAttrPos "a" { a = 0; }).file;
  src  = builtins.readFile "${origin}";

  bash     = "${pkgs.bash}/bin/bash";
  nvr      = "${pkgs.neovim-remote}/bin/nvr";
  whiptail = "${pkgs.newt}/bin/whiptail";

  checkPhase = ''
    ${utils.shellCheckers.fileIsExecutable bash}
    ${utils.shellCheckers.fileIsExecutable nvr}
    ${utils.shellCheckers.fileIsExecutable whiptail}
  '';

  pkg = writeCheckedExecutable name checkPhase ''
    #! ${bash}
    set -e
    PATH=${esc pkgs.neovim-remote}/bin:$PATH
    PATH=${esc pkgs.newt}/bin:$PATH
    ${src}
  '';
in
assert utils.valueCheckers.isNonEmptyString src;
pkg // { inherit checkPhase; originSrc = src; }
