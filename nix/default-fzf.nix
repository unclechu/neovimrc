let sources = import ./sources.nix; in
config: (import sources.nixpkgs-for-fzf { inherit config; }).fzf
