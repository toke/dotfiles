# My Dotfiles

These are (part of) my dotfiles. I'm migrating to the new repository as I touch
them. I currently use [GNU Stow][stow] to manage my symlinks, but this is optional.

More used tools: [MySetup](MySetup.md)

## Structure

Each application has it's own directory. These containing all relevant files.
If a application needs special handling I try to describe this in this README.md.
You can See an example in the [Vim Config](#vim-config).

This repository has some (`git submodule`s).

## Symlink

To "install" bash dotfiles just run `stow bash` in this directory.
Be aware that stow by default symlinks to the parent directory so
when ths checkout lives in `$HOME/.dotfiles` and you are in it and run
[stow][stow] there the symlinks are created within `$HOME`.

## Configurations

### Editorconfig (editorconfig)

[EditorConfig][editorconfig] helps developers define and maintain consistent coding styles between different editors and IDEs.

### Vim Config (vim)

I use [Plug][vim-plug] to manage vim plugins. So the old approach of using submodules is deprecated - see [Vis config](#vis-config)
for an example.
To reflect changes or initial use your Vim plugins run
`vim +PluginInstall`. Thats it.




### Vis config

I started using git subtree in the [vis][vis] config for plugins. I used the following approach:

```sh
git remote add -f vis-surround https://gitserver/user/vis-surround.git
git subtree add --prefix vis/.config/vis/plugins/vis-surround vis-surround master --squash
```

Then I added the require lines in [visrc.lua](vis/.config/vis/visrc.lua).

The command to update the sub-project at a later date becomes:

```sh
git fetch vis-surround master
git subtree pull --prefix vis/.config/vis/plugins/vis-surround vis-surround master --squash
```


[stow]: https://www.gnu.org/software/stow/
[editorconfig]: http://editorconfig.org/
[vim-plug]: https://github.com/junegunn/vim-plug
[vis]: https://github.com/martanne/vis
