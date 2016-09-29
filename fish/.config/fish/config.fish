# disable fish greeting message
set fish_greeting

# SSH agent stuff
eval (envoy -f --print)

# configure fish git prompt
set __fish_git_prompt_showdirtystate 'true'
set __fish_git_prompt_showuntrackedfiles 'true'
set __fish_git_prompt_color_branch yellow
set __fish_git_prompt_char_dirtystate '✨ '
set __fish_git_prompt_char_untrackedfiles '🆕 '


# frees up ctrl-s and ctrl-q
stty -ixon -ixoff


# Virtualenv
eval (python -m virtualfish compat_aliases)
vf activate default

set --export EDITOR "vim -f"
set --export GIT_EDITOR "vim -f"
set --export PAGER "vimpager"

# set the go path
set --export GOPATH $HOME/gocode
set --export PATH $GOPATH/bin $PATH


