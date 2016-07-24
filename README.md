NeoVimRC
========

Hot to use it
-------------

1. Clone somewhere this repo and init submodules:

  ```bash
  $ git clone https://github.com/unclechu/neovimrc ~/.neovimrc-git
  $ cd ~/.neovimrc-git
  $ git submodule update --init # need for Vundle
  ```

2. Create some symbolic links in your `HOME`:

  ```bash
  $ cd ~/.config
  $ ln -s ~/.neovimrc-git nvim
  ```

3. Install [Vundle](https://github.com/gmarik/Vundle.vim) dependencies:

  ```bash
  $ nvim +BundleInstall
  ```

4. Enjoy!

Author
------

Viacheslav Lotsmanov
