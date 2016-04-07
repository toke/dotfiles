# My Dotfiles

These are (part of) my dotfiles. I'm migrating to the new repository as I touch
them. I currently use [GNU Stow][stow] to manage
my symlinks, but this is optional. Sometimes you may choose to symlink some files
manually order to keep local modifications i.E. if you just want to add
`.gnupg/gpg.conf`.

## Structure

Each application has it's own directory. These containing all relevant files.
If a application needs special handling I try to describe this in this README.md.
You can See an example in the [Vim Config](#vim-config).

## Symlink

To "install" bash dotfiles just run `stow bash` in this directory.
Be aware that stow by default symlinks to the parent directory so
when ths checkout lives in $HOME/.dotfiles and you are in it and run
[stow][stow] there the symlinks are created within $HOME

## Configurations

### Editorconfig (editorconfig)

[EditorConfig][editorconfig] helps developers define and maintain consistent coding styles between different editors and IDEs.

### Vim Config (vim)

I use [Vundle.vim][vundle] to manage vim plugins. These Plugins are not
part of this repository (Vundle.vim is indeed a submodule).
To reflect changes or initial use your Vim plugins run
`vim +PluginInstall`. Thats it.


[stow]: https://www.gnu.org/software/stow/
[editorconfig]: http://editorconfig.org/
[vundle]: https://github.com/VundleVim/Vundle.vim
