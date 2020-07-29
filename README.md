# NeoVimRC

My own Neovim config.

## How to use

### Nix

#### Try it in a `nix-shell`

Neovim default TUI:

```sh
nix-shell -E '(import <nixpkgs> {}).mkShell {buildInputs=[(import nix/apps/neovim.nix {})];}' --run nvim
```

Neovim QT GUI:

```sh
nix-shell -E '(import <nixpkgs> {}).mkShell {buildInputs=[(import nix/apps/neovim-qt.nix {})];}' --run nvim-qt
```

#### As a NixOS system dependency

```nix
let
  pkgs = import <nixpkgs> {};

  wenzels-neovim-src = pkgs.fetchFromGitHub {
    owner = "unclechu";
    repo = "neovimrc";
    rev = "ffffffffffffffffffffffffffffffffffffffff"; # Git commit hash
    sha256 = "0000000000000000000000000000000000000000000000000000";
  };

  # See the arguments of these *.nix files.
  # These are just simple examples which use defaults.
  wenzels-neovim    = import "${wenzels-neovim-src}/nix/apps/neovim.nix"    {};
  wenzels-neovim-qt = import "${wenzels-neovim-src}/nix/apps/neovim-qt.nix" {};
in
{
  environment.systemPackages = [
    wenzels-neovim
    wenzels-neovim-qt
  ];
}
```

##### Also the scripts

```nix
let
  # … as in the example above
  clean-vim    = import "${wenzels-neovim-src}/nix/scripts/clean-vim.nix"    {};
  git-grep-nvr = import "${wenzels-neovim-src}/nix/scripts/git-grep-nvr.nix" {};
  nvimd        = import "${wenzels-neovim-src}/nix/scripts/nvimd.nix"        {};
in
{ environment.systemPackages = [ clean-vim git-grep-nvr nvimd ]; }
```

### Other GNU/Linux distributions

1. Clone this repo:

   ```sh
   git clone --recursive https://github.com/unclechu/neovimrc.git ~/.config/nvim
   ```

2. Install dependencies:

   ```sh
   nvim +PlugInstall!
   ```

## Author

Viacheslav Lotsmanov
