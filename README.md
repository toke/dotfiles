## Symlink

To "install" bash dotfiles just run `stow bash` in this directory.
Be aware that stow by default symlinks to the parent directory so
when ths checkout lives in $HOME/.dotfiles and you are in it and run
`stow` there the symlinks are created within $HOME

* [GNU Stow](https://www.gnu.org/software/stow/)


## Vim Config

I use `Vundle.vim` to manage vim plugins. These Plugins are not
part of this repository (Vundle.vim is indeed a submodule).
To reflect changes or initial use your Vim plugins run
`vim +PluginInstall`. Thats it.
