ONLINE=`{fping -q github.com && echo "true"}

all:VN: sync install

online:QV:
    fping -q github.com

sync:V: online
    git pull
    git push

install:V:
    stow bash
    stow editorconfig
    stow emojis
    stow git
    stow mksh
    stow neovim
    stow scripts
    stow shell
    stow shortcuts
    stow sway
    stow vim
    stow vifm
    stow waybar

foo:V:
    echo "foo"

foo.ref:Pcmp -s:    foo
    echo $prereq $target
