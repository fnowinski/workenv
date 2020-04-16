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

stty -ixon -ixoff
plugins=(
  git
  z
)

export EDITOR='vim'

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

# Directories
alias dub='cd /Users/frank/Projects/tc-www'
alias react='cd /Users/frank/Projects/tc-www/app/javascript_apps/'

# Git
alias master='git co master && git pull origin master && git fetch'
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
alias tags="ctags -R --exclude=node_modules --exclude=public --exclude=vendor --exclude=db --exclude=tmp"

alias rc='be rails c'
alias rs='be rails s'
alias rsd='be sidekiq'
alias rspec='be rspec'
alias gstash='git stash save'
alias glist='git stash list'
alias gpop='git stash pop'
alias lss="ls -ltr"
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

github () {
  if [ ! -d .git ]
  then
    echo "ERROR: This isnt a git directory" && return false
  fi
  base_url="https://github.com/tunecore/tc-www/pulls"
  open $base_url
}

make_pr() {
  if [ ! -d .git ] ;
    then echo "ERROR: This isnt a git directory" && return false;
  fi

  pwd | regex "tc-www" | grep "tc-www" | grep -v grep &> /dev/null
  in_tcw=$?

  if [[ $in_tcw == 0 ]]; then
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

getpip () {
  aws ec2 describe-instances --filter "Name=tag:Name,Values=tc-www-"${1}"-web-asg" | jq '.Reservations[0].Instances[0].PrivateDnsName' | sed 's/\"//g'
}

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
