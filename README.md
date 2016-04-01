## Symlink

To "install" bash dotfiles just run `stow bash` in this directory.
Be aware that stow by default symlinks to the parent directory so
when ths checkout lives in $HOME/.dotfiles and you are in it and run 
`stow` there the symlinks are created within $HOME

* [GNU Stow](https://www.gnu.org/software/stow/)

