## Bash alias file
## Needs support of bin_alias (see .bash/helper.bash:bin_alias)

### Aliases following
bin_alias vi "/usr/bin/nvim"
bin_alias vim "/usr/bin/nvim"
bin_alias pw "/usr/bin/gpwsafe"
bin_alias translate "/usr/bin/translate-shell"

bin_alias nessie "${HOME}/git/puppet-dev-env/bin/nessie"

alias ll="ls -lsa"
alias rss="newsbeuter"
alias hl="/usr/bin/highlight -O ansi"

if [[ -e /usr/bin/fzf ]] ; then
    alias vo='vim $(fzf-tmux)'
    #alias vo='vim $(fzf-file-widget)'
fi
alias zeus='dig +noall +answer @zeusmw.tool.1and1.com'
#alias winjumper="rdesktop -d "united" -u "tkerpe" -p "$(pass 1und1/owa.extranet.1and1.org/tkerpe|head -n 1)" winjumperng.united.domain'
# z.B. in die .bashrc

alias 1pass='PASSWORD_STORE_DIR=$HOME/.password-store-1und1 PASSWORD_STORE_GIT=$HOME/.password-store-1und1 pass'

# z.B. .bashrc oder .bash_completion
source /usr/share/bash-completion/completions/pass
_1pass(){
    PASSWORD_STORE_DIR=$HOME/.password-store-1und1 _pass
}
complete -o filenames -o nospace -F _1pass 1pass


alias http_serv="/usr/bin/python3 -m http.server 8082"
alias gcav="git commit -av"
alias gipu="git push"
alias gl="git log"
alias ggrep="git grep"
alias yaourt-upgrade="/usr/bin/yaourt -Syua"
alias ync='yaourt --noconfirm'

alias tw="/usr/bin/timew"
alias tws="/usr/bin/timew summary"
alias tls="/usr/bin/task ls"

alias pepe="perl -pe"
alias vimwiki="nvim -c +VimwikiIndex"

alias fixscreen="xset dpms force off"

alias se="sudo -e"
alias si="sudo -i"

alias lstimer="systemctl list-timers"

alias xmutt="st -f \"Roboto Mono Light:size=12\" -e mutt"
alias xst="st -f \"Roboto Mono Light:size=12\""

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

alias 3dcam="cvlc -q https://toke:xpal,3456@octo.home.kerpe.net/webcam/?action=stream > /dev/null"


alias ppaste="curl -F c=@- https://ptpb.pw/"


alias git-context-private="export GIT_COMMITTER_EMAIL=toke@toke.de GIT_AUTHOR_EMAIL=toke@toke.de"
alias git-context-work="export GIT_COMMITTER_EMAIL=thomas.kerpe@1und1.de GIT_AUTHOR_EMAIL=thomas.kerpe@1und1.de"


alias usystemctl="systemctl --user"
alias usys="usystemctl"

## GTD via https://taskwarrior.org/news/news.20150627.html
## use as "in"
alias in='task add +in'

## usage tick friday Feed the sheep
tickle () {
    deadline=$1
    shift
    in +tickle wait:$deadline $@
}
alias tick=tickle
## move an item another day
alias think='tickle +1d'
##
## NEEDS: html-xml-utils

webpage_title (){
    wget -qO- "$*" | hxselect -s '\n' -c  'title' 2>/dev/null
}

read_and_review (){
    link="$1"
    title=$(webpage_title $link)
    echo $title
    descr="\"Read and review: $title\""
    id=$(task add +next +rnr "$descr" | sed -n 's/Created task \(.*\)./\1/p')
    task "$id" annotate "$link"
}

alias rnr=read_and_review

alias debian="sudo systemd-nspawn -bD /srv/chroot/jessie"
