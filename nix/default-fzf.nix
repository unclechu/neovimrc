# Author: Viacheslav Lotsmanov
# License: MIT https://raw.githubusercontent.com/unclechu/neovimrc/master/LICENSE
let sources = import ./sources.nix; in
config: (import sources.nixpkgs-for-fzf { inherit config; }).fzf
