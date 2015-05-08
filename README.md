vimrc2
======

Hot to use it
-------------

1. Clone somewhere this repo and init submodules:

  ```bash
  $ git clone https://github.com/unclechu/vimrc2 ~/.vimrc2-git
  $ cd ~/.vimrc2-git
  $ git submodule update --init # need for Vundle
  ```

2. Create some symbolic links in your `HOME`:

  ```bash
  $ cd ~/
  $ ln -s ~/.vimrc2-git/.vim/
  $ ln -s ~/.vimrc2-git/.vimrc
  ```

3. Install [Vundle](https://github.com/gmarik/Vundle.vim) dependencies:

  ```bash
  $ vim +BundleInstall
  ```

4. Enjoy!

Author
------

Viacheslav Lotsmanov
