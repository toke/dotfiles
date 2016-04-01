# My Dotfiles

These are (part of) my dotfiles. I'm migrating to the new repository as I touch
them. I currently use [GNU Stow](https://www.gnu.org/software/stow/) to manage
my symlinks, but this is optional.

## Structure

Each application has it's own directory. These containing all relevant files.
If a application needs special handling I try to describe this in this README.md.
You can See an example in the [Vim Config](#vim-config).

## Symlink

To "install" bash dotfiles just run `stow bash` in this directory.
Be aware that stow by default symlinks to the parent directory so
when ths checkout lives in $HOME/.dotfiles and you are in it and run
`stow` there the symlinks are created within $HOME

## Vim Config

I use `Vundle.vim` to manage vim plugins. These Plugins are not
part of this repository (Vundle.vim is indeed a submodule).
To reflect changes or initial use your Vim plugins run
`vim +PluginInstall`. Thats it.
