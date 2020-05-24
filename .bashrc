[ ! "$UID" = "0" -a -f `which archbey` ] && archbey -c white
[  "$UID" = "0" -a -f `which archbey` ] && archbey -c green

# If not running interactively, don't do anything
# [ -z "$PS1" ] && return

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

txtred='\e[0;31m' # Red
txtgrn='\e[0;32m' # Green
bldcyn='\e[1;36m' # Cyan
txtblu='\e[1;34m' # Blue
txtpur='\e[0;35m' # Purple
txtcyn='\e[0;36m' # Cyan
txtwht='\e[0;37m' # White
txtrst='\e[0m'    # Text Reset

#PS1="\[\e[01;31m\]┌─[\[\e[01;35m\u\e[01;31m\]]──[\[\e[00;37m\]${HOSTNAME%%.*}\[\e[01;32m\]]:\w$\[\e[01;31m\]\n\[\e[01;31m\]└──\[\e[01;36m\]>>\[\e[0m\]"
#простой PS1
#PS1='[\A]\u@\h:\W\$'

#Для работы с гитом
PS1='\[\e[91m\]${?/0/}\[\e[36m\][\A]\
\[\033[0;32m\]\u@\h\[\033[00m\]:\
\[\033[01;34m\]\W\[\e[1;36m\]\
$(rvm_name)$(git_branch)\[\e[0;31m\]$(git_dirty)\[\e[0m\] $ \n\[\e[01;31m\]└──\[\e[1;36m\]>>\[\e[0m\]'

### Настройка истории
# Не запоминать дублирующиеся команды и команды с пробелом в начале
HISTCONTROL=ignoreboth
# Не запоминать дубликаты, и простые команды
export HISTIGNORE="&:reboot:shutdown *:ls:pwd:exit:man *:history:[bf]g"
# Количество строк в памяти
HISTSIZE=1024
# Количество строк в файле .bash_history
HISTFILESIZE=10240
# Формат времени (вкл. запись timestamp)
HISTTIMEFORMAT='%d.%H.%y %H:%M:%S '
# Для мгновенной записи в историю
shopt -s histappend
# Изменить заголовок на имя последней запущенной команды и убедиться, 
# что ваш файл истории команд всегда в актуальном состоянии:
export PROMPT_COMMAND='history -a;echo -en "\e]2;";history 1|sed "s/^[ \t]*[0-9]\{1,\}  //g";echo -en "\e\\";'
# Исправляем Глупые ошибки в написании
shopt -q -s cdspell
# многострочные команды будут записываться в одну строку
shopt -s cmdhist

# Переходим по каталогам без команды cd
shopt -s autocd

# проверяет размер окна при вводе каждой команды и, 
# если это необходимо, обновляет значения переменных LINES и COLUMNS.
shopt -q -s checkwinsize

# Get immediate notification of background job termination
set -o notify

# Disable [CTRL-D] which is used to exit the shell
set -o ignoreeof

# отключить сочетание Ctrl+z
trap "" 20

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
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

# Extract files from any archive
# Usage: unpack <archive_name>
unpack () {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xvjf $1    ;;
      *.tar.gz)    tar xvzf $1    ;;
      *.tar.xz)    tar xvJf $1    ;;
      *.tar.zst)   tar xvf --zstd $1 ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xvf $1     ;;
      *.tbz2)      tar xvjf $1    ;;
      *.tgz)       tar xvzf $1    ;;
      *.tzst)      tar xvf --zstd $1 ;;
      *.zip)       unzip $1       ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *.xz)        unxz $1        ;;
      *.exe)       cabextract $1  ;;
      *.zst)       unzstd $1  ;;
      *)           echo "\`$1': Unknown method of file compression" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# User specific aliases and functions
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ln='ln -i'
# do not delete / or prompt if deleting more than 3 files at a time # 
alias rm='rm -I --preserve-root'
# Parenting changing perms on / # 
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'
alias ll='ls -lah'
alias ls='ls --color=auto'
alias l.='ls -d .* --color=auto'
alias ff='echo find ./ -type f -exec grep -i -H \"STRING\"  {} \\\;'
alias cd..='cd ..'
alias .3='cd ../../../'
alias df='df -H' 
alias du='du -ch'
alias mc='env TERM=xterm-256color mc -S modarin256'
alias v='vim'
alias xz='xz -T 0'
alias 'off=systemctl poweroff'
alias '7z=7z -mmt=20'
alias 'dd=dd status=progress'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    test -r ~/.dir_colors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

alias sha1='openssl sha1'
alias bc='bc -l'
alias mkdir='mkdir -pv'

## Для раскраски diff'a надо поставить colordiff
[ -f `which colordiff` ] && alias diff='colordiff'
alias mount='mount |column -t'
alias h='history'
alias j='jobs -l'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T'
alias nowdate='date +"%d-%m-%Y"'
alias ping='ping -c 5'
alias myps='ps $@ -u $USER -o pid,%cpu,%mem,bsdtime,command ;'
# монтирование iso. общий синтаксис команды получается такой: mountiso [что] [куда]
alias mountiso='sudo mount -o loop -t iso9660'

# монтирование nrg. общий синтаксис команды получается такой: mountnrg [что] [куда]
alias mountnrg='mount -t udf,iso9660 -o loop,ro,offset=307200'

#Показываем открытые порты
alias ports='netstat -tulanp'

## Будим спящие компьютеры.
## не забываем менять mac-адрес на реальный адрес компьютера #
alias wakeupn01='/usr/bin/wakeonlan 00:11:32:11:15:FC'

# display all rules # 
alias iptlist='sudo /sbin/iptables -L -n -v --line-numbers'
alias iptlistin='sudo /sbin/iptables -L INPUT -n -v --line-numbers'
alias iptlistout='sudo /sbin/iptables -L OUTPUT -n -v --line-numbers'
alias iptlistfw='sudo /sbin/iptables -L FORWARD -n -v --line-numbers'
alias firewall=iptlist

# update on one command 
[[ -s "/etc/arch-release" ]] && alias update='yaourt -Syua --noconfirm && sync'
[[ -s "/etc/debian_version" ]] && alias update='sudo apt-get update && sudo apt-get dist-upgrade'

memcpu() {
        echo "*** Top 10 cpu eating process ***"; ps auxf | sort -nr -k 3 | head -10;
        echo  "*** Top 10 memory eating process ***"; ps auxf | sort -nr -k 4 | head -10;
}

# Show top 10 history command on screen
function ht {
  history | awk '{a[$2]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head
}

## pass options to free ## 
alias meminfo='free -m -l -t'
## get top process eating memory ##
alias psmem='ps auxf | sort -nr -k 4' 
alias psmem10='ps auxf | sort -nr -k 4 | head -10' 
## get top process eating cpu ## 
alias pscpu='ps auxf | sort -nr -k 3' 
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'
## Get server cpu info ## 
alias cpuinfo='lscpu'
## older system use /proc/cpuinfo ## 
## alias cpuinfo='less /proc/cpuinfo'
## ## get GPU ram on desktop / laptop ## 
alias gpumeminfo='grep -i --color memory /var/log/Xorg.0.log'

## Поддержка докачки в wget по умолчанию.
alias wget='wget -c'
# get web server headers # 
alias header='curl -I'

#монтирование nfs-шары на роутере
alias mountshare = 'sudo mount -o 'vers=3' 192.168.1.1:/media/AiDisk_a2 /mnt/nfs/'

# Алиасы для git
alias gs='git status '
alias ga='git add '
alias gb='git branch '
alias gc='git commit'
alias gd='git diff'
alias go='git checkout '
alias gk='gitk --all&'
alias gx='gitx --all'
alias got='git '
alias get='git '
alias пше='git '
alias glp="git pull && git push"
alias gmne="git merge --no-edit"
alias spull = "!git stash && git pull --rebase && git stash pop"
alias spush = "!git stash && git pull --rebase && git push && git stash pop"
alias ameno = 'commit --amend --no-edit'

gitclosepullrequest () {
    local status branch
    status="$(git status 2>/dev/null)"
    [[ $? != 0 ]] && return;
    branch="$(git branch | perl -ne '/^\* (.*)/ && print $1')"
    git fetch origin master:master && git checkout master && git branch -d ${branch}
}

# вывод признака системы контроля версии и относительного
# пути в репозитории
git_branch() {
	git_branch=$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1/")
	[ "$git_branch" != "" ] && echo ":git/$git_branch "
}

# вывод признака наличия изменений в репозитории
git_dirty() {
    [ $(git status --short 2> /dev/null | wc -l) != 0 ] && \
        echo -e "*"
}

if [ -f ~/.oh-my-git/prompt.sh ]; then
  foreground=124
  background=236
  omg_last_symbol_color="\[\033[38;5;${foreground}m\]\[\033[48;5;${background}m\]"
  source /home/arch/.oh-my-git/prompt.sh
fi

#для tmux
alias tmux='TERM=screen-256color tmux'
export TERM=xterm-256color

#если screen с сессией live не запущен, запустить его и перейти в него, если сессия live есть, 
#и не подключена ни к одному терминалу просто войдем в эту сессию, если сессия live существует и подключена на другом терминале, то сообщим об этом, ждем 2 секунды и войдем в сессию, а если мы находимся в этой сессии, то просто сообщаем, что уже тут.
#Те все, что мне нужно сделать в терминале после перезагрузки (бывает и такое) это набрать live. 
#На работе не забыть нажать C-a d, а по приходу домой просто набрать live. 
alias live='
if [ -n "`screen -ls | grep LIVE`" ]; then 
    if [ -n "`screen -ls | grep LIVE | grep Attached`" ]; then 
        if [ -z "`echo $TERMCAP | grep screen`" ]; then 
            echo "Enter into Atached screen"; 
            sleep 2; 
            screen -x LIVE ; 
        else 
            echo "in LIVE" ; 
        fi 
    else 
        screen -r LIVE ; 
    fi  
else 
    screen -S LIVE -c .screenrc.live ; 
fi'







# Wrapper for host and ping command
# Accept http:// or https:// or ftps:// names for domain and hostnames
_getdomainnameonly(){
        local h="$1"
        local f="${h,,}"
        # remove protocol part of hostname
        f="${f#http://}"
        f="${f#https://}"
        f="${f#ftp://}"
        f="${f#scp://}"
        f="${f#scp://}"
        f="${f#sftp://}"
        # remove username and/or username:password part of hostname
        f="${f#*:*@}"
        f="${f#*@}"
        # remove all /foo/xyz.html*
        f=${f%%/*}
        # show domain name only
        echo "$f"
}


pingf(){
        local array=( $@ )              # get all args in an array
        local len=${#array[@]}          # find the length of an array
        local host=${array[$len-1]}     # get the last arg
        local args=${array[@]:0:$len-1} # get all args before the last arg in $@ in an array
        local _ping="/bin/ping"
        local c=$(_getdomainnameonly "$host")
        [ "$t" != "$c" ] && echo "Sending ICMP ECHO_REQUEST to \"$c\"..."
        # pass args and host
        $_ping $args $c
}

hostf(){
        local array=( $@ )
        local len=${#array[@]}
        local host=${array[$len-1]}
        local args=${array[@]:0:$len-1}
        local _host="/usr/bin/host"
        local c=$(_getdomainnameonly "$host")
        [ "$t" != "$c" ] && echo "Performing DNS lookups for \"$c\"..."
        $_host $args $c
}

export VIRSH_DEFAULT_CONNECT_URI=qemu:///system

# версию Ruby
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

rvm_name() {
  local gemset=$(echo $GEM_PATH | awk -F'/' '{print $NF}')
  [ "$gemset" != "" ] && echo "[$gemset]"
}