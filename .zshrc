export ZSH=/Users/frank/.oh-my-zsh
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH=".git/safe/../../bin:$PATH"

eval "$(rbenv init -)"

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
alias social='cd /Users/frank/Projects/tc-social'
alias stats='cd /Users/frank/Projects/stats'
alias petri='cd /Users/frank/Projects/petri'
alias sip='cd /Users/frank/Projects/Sip'
alias tunecore='cd /Users/frank/Projects/tunecore/'
alias blog='cd /Users/frank/Projects/blog/'

# Git
alias master='git co master && git pull origin master && git fetch'
alias amend='git commit --amend --no-edit'
alias push='git push -f origin HEAD'
alias gdm="git diff master...$(git name-rev --name-only HEAD)"
alias gst="git status"
alias diff="git diff"
alias gco="git co"
alias gadd="git add ."
alias gcont="git rebase --continue"
alias gpush="git push origin head"
alias grebase="git rebase -i origin/master"

# Commands
alias c="clear"
alias @='where am i'
alias be='bundle exec'
alias pryr="prybaby -r"
alias tkill="killall tmux"
alias tnew="tmux new -s "
alias secrets='./docker/pull_secrets.sh'

alias ors='lsof -wni tcp:3000'
alias osp='ps -ef | grep spring'
alias kill_spring='ps aux | grep spring | grep -v "grep" | awk "{print $2}" | xargs kill'
alias ngr='sudo pkill nginx;sudo nginx'
alias tags="ctags -R --exclude=node_modules --exclude=public --exclude=vendor --exclude=db --exclude=tmp"
alias kside="ps -ef | grep sidekiq | grep -v grep | awk '{print $2}' | xargs kill - -ef | grep sidekiq | grep -v grep | awk '{print $2}' | xargs kill -9"
alias call="caller.select { |x| x.include?('/tc-www/app')  }"

# Docker
alias docker_start='docker-sync-stack start'
alias dcon='docker-compose exec puma bundle exec rails console'
alias dconpro='docker-compose exec -e DATABASE_URL=$PRODB_RO puma bundle exec rails console'
alias scon='docker-compose exec social-web bundle exec rails console'
alias drspec='docker-compose exec test bundle exec rspec'
alias dspec='docker-compose exec test bundle exec spring rspec'
alias docker_stop='docker-compose down'
alias docker_destroy='docker rmi -f `docker images -q -a`'
alias brew_start="brew services start mariadb; brew services start postgresql; brew services start redis; sudo brew services start nginx"
alias brew_stop="brew services stop mariadb; brew services stop postgresql; brew services stop redis; sudo brew services stop nginx"
alias dload_test="docker-compose exec test rake db:load"

alias rcon='be rails c'
alias rstart='be rails s'
alias rspec='be rspec'
alias Z='fg'
alias rup0='git co rails_upgrade && git pull origin rails_upgrade'
alias rup1='git co rails_upgrade_4_1 && git pull origin rails_upgrade_4_1'
alias rup2='git co rails_4_2 && git pull origin rails_4_2'
alias gstash='git stash save'
alias glist='git stash list'
alias gpop='git stash pop'

# Terminate open port
Terminate () {
  lsof -i TCP:$1 | grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn} IPv4 | awk '{print $2}' | xargs kill -9
}

scratch () {
  vim scratch.rb
}

# Start Docker - tc-www
dstart() {
  docker_stop;
  docker-sync clean;
  docker_start;
}

# Start Docker - tc-social
sstart() {
  docker-compose down;
  docker-compose up;
}

# Rebuild Docker Containers
docker_refresh() {
  docker_stop;
  docker_destroy;
  docker_start;
}

dtail() {
  docker-compose exec $1 tail -f log/$1.log
}

dpry () {
  web_pid=$(docker ps | grep tc-www_puma | awk '{print $1}')
  docker attach $web_pid
}

spry () {
  web_pid=$(docker ps | grep social-web | awk '{print $1}')
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

ssh_qa () {
  ssh -i ~/.ssh/tunecore1.pem ec2-user@$(get_aws_server "qa"$1)
}

ssh_dev () {
  ssh -i ~/.ssh/tunecore1.pem ec2-user@$(get_aws_server "dev"$1)
}

find () {
  grep -riIl $1 . --exclude="./cache/*"
}

get_ticket () {
  [ ! -d .git ] && echo "ERROR: This isnt a git directory" && return

  curr_branch=$(git branch | grep '\*' | cut -d ' ' -f2-)
  ticket_id=`echo ${curr_branch%/*} | tr 'a-z' 'A-Z'`

  ticket_id
}

source $ZSH/oh-my-zsh.sh
source $HOME/.zshenv
eval "$(direnv hook zsh)"
export PATH="/usr/local/sbin:$PATH"
#export PATH="/usr/local/opt/mariadb@10.1/bin:$PATH"
