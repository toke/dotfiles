## Bash alias file
## Needs support of bin_alias (see .bash/helper.bash:bin_alias)

### Aliases following
bin_alias vi "/usr/bin/vim"
bin_alias pw "/usr/bin/gpwsafe"
bin_alias translate "/usr/bin/translate-shell"

bin_alias nessie "${HOME}/git/puppet-dev-env/bin/nessie"

alias ll="ls -lsa"

alias gcav="git commit -av"
alias gl="git log"
alias ggrep="git grep"

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


