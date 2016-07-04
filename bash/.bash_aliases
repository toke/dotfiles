## Bash alias file
## Needs support of bin_alias (see .bash/helper.bash:bin_alias)

### Aliases following
bin_alias vi "/usr/bin/vim"
bin_alias pw "/usr/bin/gpwsafe"
bin_alias translate "/usr/bin/translate-shell"

bin_alias nessie "${HOME}/git/puppet-dev-env/bin/nessie"

alias ll="ls -lsa"

if [[ -e /usr/bin/fzf ]] ; then
    alias vo='vim $(fzf-tmux)'
    #alias vo='vim $(fzf-file-widget)'
fi
alias zeus='dig +noall +answer @zeusmw.tool.1and1.com'

alias http_serv="/usr/bin/python3 -m http.server 8082"
alias gcav="git commit -av"
alias gl="git log"
alias ggrep="git grep"
alias yaourt-upgrade="/usr/bin/yaourt -Syua"

## Docker specific aliases
if [[ $(command -v "docker") ]] ; then
    # Kill all running containers.
    alias docker-killall='docker kill $(docker ps -q)'

    # Delete all stopped containers.
    alias docker-cleanc='printf "\n>>> Deleting stopped containers\n\n" && docker rm $(docker ps -a -q)'

    # Delete all untagged images.
    alias docker-cleani='printf "\n>>> Deleting untagged images\n\n" && docker rmi $(docker images -q -f dangling=true)'

    # Delete all stopped containers and untagged images.
    alias docker-clean='docker-cleanc || true && docker-cleani'
fi


