export ZSH=/Users/frank/.oh-my-zsh
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH=".git/safe/../../bin:$PATH"

eval "$(rbenv init -)"

#export TERM=xterm

# Source files
for file in ~/.tunecorerc; do
  source "$file"
done

if [ -z "$SSH_AUTH_SOCK" ] ; then
  eval `ssh-agent -s`
  ssh-add
fi

# Themes
ZSH_THEME="cobalt2"
HYPHEN_INSENSITIVE="true"
HIST_STAMPS="mm/dd/yyyy"

if [[ -n $SSH_CONNECTION ]]; then
  export TERM=xterm
else
  export EDITOR='vim'
fi

stty -ixon -ixoff
plugins=(
  git
  z
  forgit
)

bindkey -e

# Refresh zsh
alias rz="source $ZSH/oh-my-zsh.sh"

# Config Files
alias vcon="vim ~/.vimrc"
alias zcon="vim ~/.zshrc"
alias bcon="vim ~/.bash_profile"
alias tcon='vim ~/.tunecorerc'
alias mcon="vim ~/.tmux.conf"
alias omz="vim ~/.oh-my-zsh"
alias gcon='vim ~/.gitconfig'
alias aliases='vim ~/.bash_profile'
alias ff='fzf'
alias cat="bat"
alias ls="exa"

# Directories
alias dub='cd /Users/frank/Projects/tc-www'
alias react='cd /Users/frank/Projects/tc-www/app/javascript_apps/'

# Git
alias master='git co master && git pull origin master && git fetch'
alias integration='git co integration && git pull origin integration && git fetch'
alias amend='git commit --amend --no-edit'
alias push='git push -f origin HEAD'
alias gst="git status"
alias diff="git diff"
alias gco="git co"
alias gadd="git add ."
alias gcont="git rebase --continue"
alias gpush="git push origin head"
alias gpull="git pull origin --rebase"
alias grebase="git rebase -i origin/master"
alias migrate="bundle exec rake db:migrate"

# Commands
alias c="clear"
alias @='where am i'
alias be='bundle exec'
alias tkill="killall tmux"
alias tnew="tmux new -s "
alias tdev="tmux a -t dev"
alias secrets='./docker/pull_secrets.sh'
alias ors='lsof -wni tcp:3000'
alias kill_spring='ps aux | grep spring | grep -v "grep" | awk "{print $2}" | xargs kill'
alias tags="ctags -R --exclude=node_modules --exclude=public --exclude=db --exclude=tmp"

alias rc='be rails c'
alias rs='be rails s'
alias rsd='be sidekiq'
alias rspec='be rspec'
alias gstash='git stash save'
alias glist='git stash list'
alias gpop='git stash pop'
alias lss="ls -ltr"
alias al="ls -al"
alias ssh='TERM=xterm-256color ssh'
alias Z='fg'

# Docker
alias docker_start='docker-sync-stack start'
alias dcon='docker-compose exec puma bundle exec rails console'
alias drspec='docker-compose exec test bundle exec rspec'
alias dspec='docker-compose exec test bundle exec spring rspec'
alias docker_stop='docker-compose down'
alias docker_destroy='docker rmi -f `docker images -q -a`'
alias brew_start="brew services start mariadb; brew services start postgresql; brew services start redis; sudo brew services start nginx"
alias brew_stop="brew services stop mariadb; brew services stop postgresql; brew services stop redis; sudo brew services stop nginx"

# When switching over to rails 6:
# gem uninstall method_source -v 0.9.2
# require 'bootsnap/setup' unless ENV["ZEUS_MASTER_FD"]

# Terminate open port
Terminate () {
  lsof -i TCP:$1 | grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn} IPv4 | awk '{print $2}' | xargs kill -9
}

scratch () {
  vim scratch.rb
}

dstart() {
  docker_stop;
  docker-sync clean;
  docker_start;
}

# Rebuild Docker Containers
docker_refresh() {
  docker_stop;
  docker_destroy;
  docker_start;
}

dpry () {
  web_pid=$(docker ps | grep tc-www_puma | awk '{print $1}')
  docker attach $web_pid
}

dsync () {
  docker-compose exec test cat $1 | diff $1 - -w -s
}

dcopy () {
  docker cp $(docker ps -qf "name=puma"):tc-www/$1 $1
}

drake () {
  commands_array=($@)
  len=${#commands_array[@]}
  other_commands=${commands_array[@]:2:$len-1}
  docker-compose exec $1 rake $2 $other_commands
}

dbash () {
  commands_array=($@)
  len=${#commands_array[@]}
  other_commands=${commands_array[@]:2:$len-1}
  docker-compose exec $1 bash
}

dimage () {
  docker images | grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn} $1 | awk '{print $3}'
}

dmigrate() {
  drake $1 $2 && dcopy db/structure.sql
}

docker_migrate() {
  docker_migrate_db $1 db:migrate
}

docker_rollback() {
  docker_migrate_db $1 db:rollback
}

dcon_qa1() {
  docker-compose exec -e DATABASE_URL=$QA1_DB puma bundle exec rails console
}

dcon_pro() {
  docker-compose exec -e DATABASE_URL=$PRODB_RO puma bundle exec rails console
}

cob() {
  git co $(git branch | fzf)
}

github () {
  if [ ! -d .git ]
  then
    echo "ERROR: This isnt a git directory" && return false
  fi
  base_url="https://github.com/tunecore/tc-www/pulls"
  open $base_url
}

makepr() {
  if [ ! -d .git ] ;
    then echo "ERROR: This isnt a git directory" && return false;
  fi

  pwd | regex "tc-www" | grep "tc-www" | grep -v grep &> /dev/null
  in_tcw=$?

  pwd | regex "studio" | grep "studio" | grep -v grep &> /dev/null
  in_studio=$?

  pwd | regex "graph" | grep "graph" | grep -v grep &> /dev/null
  in_graph=$?

  if [[ $in_tcw == 0 ]] || [[ $in_studio == 0 ]] || [[ $in_graph == 0  ]]; then
    compare="/compare/integration...";
  else
    compare="/compare/master...";
  fi
  expand="?expand=1"
  branch=`git branch | grep \* | cut -d ' ' -f2-`
  github_url="https://github.com/tunecore/"
  url=$github_url$(git_repo)$compare$branch$expand

  open $url
}

aws_login () {
  $(aws ecr get-login --no-include-email --region us-east-1)
}

git_repo () {
  if [ ! -d .git ]
  then
    echo "ERROR: This isnt a git directory" && return false
  fi
  git config --get remote.origin.url | regex "\/(.*)\.git" 1
}

regex () {
  gawk 'match($0,/'$1'/, ary) {print ary['${2:-'0'}']}'
}

get_aws_server () {
  filter="Name=tag:Name,Values=ECS Instance - EC2ContainerService-tc-www-staging-"$1
  aws ec2 describe-instances --filter $filter | jq '.Reservations[0].Instances[0].NetworkInterfaces[0].PrivateIpAddresses[0].Association.PublicDnsName' | sed 's/\"//g'
}

find () {
  grep -riIl $1 . --exclude="./cache/*"
}

getip () {
  aws ec2 describe-instances | jq -r '.Reservations[].Instances[] | select(contains({Tags: [{Key: "Name"}]})) | select(.Tags[].Value | test("tc-www-staging-'"$1"'$")) | .PublicIpAddress' | head -1
}

# WIP
getprodip(){
  aws ec2 describe-instances | jq -r '.Reservations[].Instances[] | select(contains({Tags: [{Key: "Name"}]})) | select(.Tags[].Value | test("ECS Instance - EC2ContainerService-tc-www-production-web")) | .PublicIpAddress' | head -1
}

#getpip () {
  #aws ec2 describe-instances --filter "Name=tag:Name,Values=tc-www-"${1}"-web-asg" | jq '.Reservations[0].Instances[0].PrivateDnsName' | sed 's/\"//g'
#}

tsh () {
  servername=${1:-"dev1"}
  serverip=$(getip "$servername")
  if [ -z "$serverip" ] || [ "$serverip" = "null" ]; then
    echo "Server Not Found"
    exit 1
  fi
  ssh -i ~/.ssh/tunecore1.pem ec2-user@"$serverip"
}

scp_bside () {
  scp -i ~/.ssh/tunecore1.pem $1 centos@metronome.tunecore.com:/tmp
}

scp_staging () {
  serverip=$(getip $1)
  scp -i ~/.ssh/tunecore1.pem $2 ec2-user@"$serverip":
}

scp_from_bside () {
  scp -i ~/.ssh/tunecore1.pem centos@metronome.tunecore.com:/tmp/$1 ~/Downloads/
}

eval "$(direnv hook zsh)"
export PATH="/usr/local/sbin:$PATH"
source $ZSH/oh-my-zsh.sh
source $HOME/.zshenv

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Ignore directories
#https://github.com/junegunn/fzf.vim/issues/45://github.com/junegunn/fzf.vim/issues/453

bindkey ',m' fzf-file-widget
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git/*'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :500 {}'"
export FZF_ALT_C_COMMAND='fd --type d . --color=never'
export FZF_DEFAULT_OPTS='
  --height 75% --multi
  --bind ctrl-f:page-down,ctrl-b:page-up
  --bind ctrl-p:abort
  --color=fg:-1,bg:-1,hl:#5fd7ff
  --color=fg+:-1,bg+:-1,hl+:#79e7fa
  --color=info:#87ff00,prompt:#ff76ff,pointer:#ff76ff
  --color=marker:#87ff00,spinner:#00c5c7,header:#00c5c7
  --color=preview-fg:#87ff00
'
export PATH="$HOME/.rbenv/bin:$PATH"

fif() {
    if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
    local file
    file="$(rga --max-count=1 --ignore-case --files-with-matches --no-messages "$@" | fzf-tmux +m --preview="rga --ignore-case --pretty --context 10 '"$@"' {}")" && open "$file"
}

fe() (
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
)

fh() {
  eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -r 's/ *[0-9]*\*? *//' | sed -r 's/\\/\\\\/g')
}

fcs() {
  local commits commit commits=$(git log --color=always --pretty=oneline --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --tac +s +m -e --ansi --reverse) &&
  echo -n $(echo "$commit" | sed "s/ .*//")
}

fstash() {
  local out q k sha
  while out=$(
    git stash list --pretty="%C(yellow)%h %>(14)%Cgreen%cr %C(blue)%gs" |
    fzf --ansi --no-sort --query="$q" --print-query \
        --expect=ctrl-d,ctrl-b);
  do
    mapfile -t out <<< "$out"
    q="${out[0]}"
    k="${out[1]}"
    sha="${out[-1]}"
    sha="${sha%% *}"
    [[ -z "$sha" ]] && continue
    if [[ "$k" == 'ctrl-d' ]]; then
      git diff $sha
    elif [[ "$k" == 'ctrl-b' ]]; then
      git stash branch "stash-$sha" $sha
      break;
    else
      git stash show -p $sha
    fi
  done
}

function git-fixup () {
  git ll -n 20 | fzf | cut -f 1 | xargs git commit --no-verify --fixup
}

function cd() {
    if [[ "$#" != 0 ]]; then
        builtin cd "$@";
        return
    fi
    while true; do
        local lsd=$(echo ".." && ls -p | grep '/$' | sed 's;/$;;')
        local dir="$(printf '%s\n' "${lsd[@]}" |
            fzf --reverse --preview '
                __cd_nxt="$(echo {})";
                __cd_path="$(echo $(pwd)/${__cd_nxt} | sed "s;//;/;")";
                echo $__cd_path;
                echo;
                ls -p --color=always "${__cd_path}";
        ')"
        [[ ${#dir} != 0 ]] || return 0
        builtin cd "$dir" &> /dev/null
    done
}

getpip () {
  # aws ec2 describe-instances --filters "Name=tag:Name,Values=$1" | jq -r '.Reservations[].Instances[] | .PrivateIpAddress' | head -1
  aws ec2 describe-instances | jq -r '.Reservations[].Instances[] | select(contains({Tags: [{Key: "Name"}]})) | select(.Tags[].Value | test("'"$1"'")) | .PrivateIpAddress' | head -1
}

ssh_user () {
  name=${1:-"tc-www-dev1-web-asg"}
  serverip=$(getpip "$name")
  ssh -i ~/.ssh/tunecore1.pem root@$serverip exit 2>&1 | sed 's/.*as the user "\([^"]*\)".*/\1/'
}

ssh_tc () {
  name=${1:-"tc-www-dev1-web-asg"}
  serverip=$(getpip "$name")
  ssh -q -i ~/.ssh/tunecore1.pem -tt ec2-user@$serverip ${@:2}
}

ssh_cmd () {
  servername=${1:-"tc-www-dev1-web-asg"}
  cmd=${@:2}
  [ -z "$cmd" ] && cmd="rails console"
  ssh_tc $servername 'docker exec -it $\(docker ps -qf "expose=3000"\) ./docker/environment.sh '$cmd
}

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

#forgit_log=glo
#forgit_diff=gd
#forgit_add=ga
#forgit_reset_head=grh
#forgit_ignore=gi
#forgit_restore=gcf
#forgit_clean=gclean
#forgit_stash_show=gss
