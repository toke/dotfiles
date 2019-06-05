DEFAULT_PKGS="bash editorconfig emojis git mksh nvim scripts shell shortcuts sway vim vifm waybar scripts youtube-dl"

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
