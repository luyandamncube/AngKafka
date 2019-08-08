# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

################################################

# LUYANDA'S ALIASES

export ZOOKEEPER_HOME=/home/luyanda/zookeeper-3.4.14
export ZOOKEEPER_ZIP=/home/luyanda/zookeeper-3.4.14.tar.gz	

export KAFKA_HOME=/home/luyanda/kafka_2.12-2.2.0
export KAFKA_ZIP=/home/luyanda/kafka_2.12-2.2.0.tgz	
export KAFKA_CONF_DIR=$KAFKA_HOME/config
export KAFKA_CLASSPATH=$KAFKA_CONF_DIR
export PATH=$KAFKA_HOME/bin:$PATH

# start zookeeper server
alias zstart='sudo $ZOOKEEPER_HOME/bin/zkServer.sh start'

# start zookeeper cli
alias zc='sudo $ZOOKEEPER_HOME/bin/zkCli.sh -server localhost:2181'

# start kafka server
alias kstart='cd /tmp/ && sudo rm -rf kafka-logs && sudo rm -rf zookeeper && cd ~ sudo $KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_CONF_DIR/server.properties'

# start zookeeper server & kakfa server 
alias zkstart='sudo $ZOOKEEPER_HOME/bin/zkServer.sh start && cd /tmp/ && sudo rm -rf kafka-logs && cd ~ && sudo $KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_CONF_DIR/server.properties'

# stop kafka server
alias kstop='sudo $KAFKA_HOME/bin/kafka-server-stop.sh'

# stop zookeeper server
alias zstop='sudo $ZOOKEEPER_HOME/bin/zkServer.sh stop'

# start zookeeper server & kakfa server 
alias zkstop='sudo $KAFKA_HOME/bin/kafka-server-stop.sh && sudo $ZOOKEEPER_HOME/bin/zkServer.sh stop'

# list all kafka topics
alias ktla='$KAFKA_HOME/bin/kafka-topics.sh --zookeeper localhost:2181 --list'

# list kafka topics on current server
alias ktl='$KAFKA_HOME/bin/kafka-topics.sh --list --bootstrap-server localhost:9092'

# create kafka topics (usage: ktc <TOPIC_NAME>)
ktc(){ $KAFKA_HOME/bin/kafka-topics.sh --create --bootstrap-server localhost:9092 --replication-factor 1 --partitions 1 --topic "$1"; }

# create kafka topic consumer (usage: ktcc <TOPIC_NAME>)
ktcc(){ $KAFKA_HOME/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic "$1" --from-beginning; }

# create kafka topic producer (usage: ktcp <TOPIC_NAME>)
ktcp(){ $KAFKA_HOME/bin/kafka-console-producer.sh --broker-list localhost:9092 --topic "$1"; }

# Delete Zookeeper + Kafka and unzip new installation
zkreset(){ 
	 sudo rm -rf /home/luyanda/zookeeper-3.4.14/ &&
	 sudo rm -rf /home/luyanda/kafka_2.12-2.2.0/ &&
	 sudo tar xvzf /home/luyanda/zookeeper-3.4.14.tar.gz &&
	 sudo tar xvzf /home/luyanda/kafka_2.12-2.2.0.tgz
}

# override kafka broker (usage: kb <BROKER_ID>)
kb(){ 
	 sudo rm -rf /tmp/kafka-logs && sudo rm -rf /tmp/zookeeper && cd ~ && \
		sudo $ZOOKEEPER_HOME/bin/zkServer.sh start && \ 
		sudo $KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_CONF_DIR/server.properties \
		--override delete.topic.enable=true \
		--override broker.id="$1" \
		--override log.dirs=/tmp/kafka-logs \

		--override port=9092
}
# list details for kafka topic (usage: kti <TOPIC_NAME>)
kti(){ 
	$KAFKA_HOME/bin/kafka-topics.sh --zookeeper \
		localhost:2181 --describe --topic "$1"
}

# delete kafka topics (usage: ktd <TOPIC_NAME>)
ktr(){ 
	echo rmr /brokers/topics/"$1" | sudo $ZOOKEEPER_HOME/bin/zkCli.sh -server localhost:2181
}

# delete kafka logs
alias klogs='sudo rm -rf /tmp/kafka-logs && sudo rm -rf /tmp/zookeeper && sudo rm -rf /home/luyanda/kafka_2.12-2.2.0/logs'


################################################




# If not running interactively, don't do anything
case $- in
	*i*) ;;
	*) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
	xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
		# We have color support; assume it's compliant with Ecma-48
		# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
		# a case would tend to support setf rather than setaf.)
		color_prompt=yes
	else
		color_prompt=
	fi
fi

if [ "$color_prompt" = yes ]; then
	PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
	PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
	xterm*|rxvt*)
		PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
		;;
	*)
		;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto'
	#alias dir='dir --color=auto'
	#alias vdir='vdir --color=auto'

	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -la'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi
