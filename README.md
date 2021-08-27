# NeoVimRC

My own Neovim config.

## How to use

### Nix

#### Try it in a `nix-shell`

Neovim default TUI:

``` sh
nix-shell --run nvim
```

Neovim QT GUI:

``` sh
nix-shell --arg with-neovim-qt true --run nvim-qt
```

Neovide GUI:

_N.B. At the moment Neovide is broken in stable “nixpkgs”. That’s why it is picked from unstable._

``` sh
nix-shell --arg with-neovide true --arg pkgs 'import <nixos-unstable> {}' --run neovide
```

Turn everything on:

``` sh
nix-shell \
  --arg with-neovim-qt           true \
  --arg with-neovide             true \
  --arg with-clean-vim-script    true \
  --arg with-git-grep-nvr-script true \
  --arg with-nvimd-script        true
```

#### As a NixOS system dependency

``` nix
{ pkgs, ... }:
let
  wenzels-neovim-src = pkgs.fetchFromGitHub {
    owner = "unclechu";
    repo = "neovimrc";
    rev = "ffffffffffffffffffffffffffffffffffffffff"; # Git commit hash
    sha256 = "0000000000000000000000000000000000000000000000000000";
  };

  # See the arguments of these *.nix files.
  # These are just simple examples which use defaults.
  wenzels-neovim    = pkgs.callPackage "${wenzels-neovim-src}/nix/apps/neovim.nix"    {};
  wenzels-neovim-qt = pkgs.callPackage "${wenzels-neovim-src}/nix/apps/neovim-qt.nix" {};
  wenzels-neovide   = pkgs.callPackage "${wenzels-neovim-src}/nix/apps/neovide.nix" {};
in
{
  environment.systemPackages = [
    wenzels-neovim
    wenzels-neovim-qt
    wenzels-neovide
  ];
}
```

##### Also the scripts

``` nix
{ pkgs, ... }:
let
  wenzels-neovim-src = pkgs.fetchFromGitHub {
    owner = "unclechu";
    repo = "neovimrc";
    rev = "ffffffffffffffffffffffffffffffffffffffff"; # Git commit hash
    sha256 = "0000000000000000000000000000000000000000000000000000";
  };

  clean-vim    = pkgs.callPackage "${wenzels-neovim-src}/nix/scripts/clean-vim.nix"    {};
  git-grep-nvr = pkgs.callPackage "${wenzels-neovim-src}/nix/scripts/git-grep-nvr.nix" {};
  nvimd        = pkgs.callPackage "${wenzels-neovim-src}/nix/scripts/nvimd.nix"        {};
in
{ environment.systemPackages = [ clean-vim git-grep-nvr nvimd ]; }
```

### Other GNU/Linux distributions

1. Clone this repo:

   ``` sh
   git clone --recursive https://github.com/unclechu/neovimrc.git ~/.config/nvim
   ```

2. Install dependencies:

   ``` sh
   nvim +PlugInstall!
   ```

## Author

Viacheslav Lotsmanov

## License

[MIT] — For the code of this repository.
Some third-party dependencies may have different licenses.

[MIT]: LICENSE
