# Author: Viacheslav Lotsmanov
# License: MIT https://raw.githubusercontent.com/unclechu/neovimrc/master/LICENSE

# This module is intended to be called with ‘nixpkgs.callPackage’
{ vimPlugins
}:

# These plugins are lacking license information and marked as “unfree”.
# These plugins are typically old and not updated for years so it’s unlikely
# that the situation changes.
[
  vimPlugins.vim-indexed-search # https://github.com/henrik/vim-indexed-search
  vimPlugins.delimitMate # https://github.com/raimondi/delimitMate
  vimPlugins.vim-hoogle # https://github.com/twinside/vim-hoogle
  vimPlugins.rainbow_parentheses-vim # https://github.com/kien/rainbow_parentheses.vim
  vimPlugins.vim-pug # https://github.com/digitaltoad/vim-pug
  vimPlugins.vim-janah # https://github.com/mhinz/vim-janah
]
