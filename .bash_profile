export PATH=/Users/woode/.local/bin:/usr/local/bin:/usr/local/share/npm/bin:$PATH

export PGPASSWORD=postgres
export PGHOST=localhost

export ONESOURCE_HOME=~/workspace/onesource/webapp

export ANDROID_HOME=$HOME/Library/Android/sdk
export JAVA_HOME="$(/usr/libexec/java_home)"
export PATH=/Library/PostgreSQL/9.3/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$PATH
export JREBEL_ARGS="-javaagent:/Users/woode/dev/jrebel/jrebel.jar -Drebel.lift_plugin=true -Drebel.logback_plugin=true"
export ES_HEAP_SIZE=2048M

export JAVA_HOME=`/usr/libexec/java_home -v 1.8`

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi
# .NET CLR
source dnvm.sh

# The next line updates PATH for the Google Cloud SDK.
if [ -f /Users/WOODT/sdks/google-cloud-sdk/path.bash.inc ]; then
  source '/Users/WOODT/sdks/google-cloud-sdk/path.bash.inc'
fi

# The next line enables shell command completion for gcloud.
if [ -f /Users/WOODT/sdks/google-cloud-sdk/completion.bash.inc ]; then
  source '/Users/WOODT/sdks/google-cloud-sdk/completion.bash.inc'
fi

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"

source ~/.profile

# bash-completion
if [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
  . /opt/local/etc/profile.d/bash_completion.sh
fi

alias elastic="/opt/elasticsearch-6.2.3/bin/elasticsearch"
alias kibana="/opt/kibana/bin/kibana"

alias up="docker-compose up"
alias stop="docker-compose stop"

alias dbh="~/workspace/onesource/webapp/sbt tomcat:quickstart shell"

alias fetch="~/fetch"
alias db="~/db"
alias jump="ssh jump"

alias pg_stop="sudo -u postgres pg_ctl -D /Library/PostgreSQL/9.6/data stop"
alias pg_start="sudo -u postgres pg_ctl -D /Library/PostgreSQL/9.6/data start"

alias webapp="cd ~/workspace/onesource/webapp"

alias shapeless="curl -s https://raw.githubusercontent.com/milessabin/shapeless/master/scripts/try-shapeless.sh | bash"

proxy-go() {
  yarn config set http-proxy 'http://woode:Castille2018@158.151.208.51:8080' -g
  yarn config set https-proxy 'http://woode:Castille2018@158.151.208.51:8080' -g
}

proxy-no-go() {
  yarn config delete http-proxy -g
  yarn config delete https-proxy -g
}

kill-port() {
  if [ -z $1 ]; then
    echo "give me a port"
  else
    lsof -i ":$1" | sed 's/\|/ /' | awk 'NR>1{print $2}' | xargs kill -9
  fi
}

kill-docker-port() {
	PORT=$1
	ID=`docker container list | tail -n +2 | awk '/:8080/' | awk -F" " '{ print $1 }'`
	if [[ ! -z "$ID" ]]; then
		docker container stop $ID
		echo "stopped container $ID"
	fi
}

kube-token() {
    kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')
}

#source /Users/woode/.rvm/scripts/rvm

export GPG_TTY=$(tty)


# added by Anaconda3 5.2.0 installer
export PATH="/anaconda3/bin:$PATH"

# Git branch in prompt.

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

export PS1="\h:\W \u\[\033[2m\]\$(parse_git_branch)\[\033[00m\] $ "

fortune
