DEFAULT_PKGS="bash editorconfig emojis git mksh neovim scripts shell shortcuts sway vim vifm waybar scripts"

all:VN: sync install

online:QV:
    fping -q github.com

sync:V: online
    git pull
    git push

install:V: 
    stow $DEFAULT_PKGS

foo:V:
    echo "foo"

foo.ref:Pcmp -s:    foo
    echo $prereq $target
