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

# версию Ruby
rvm_name() {
  local gemset=$(echo $GEM_PATH | awk -F'/' '{print $NF}')
  [ "$gemset" != "" ] && echo "[$gemset]"
}

### Настройка истории
# Не запоминать дублирующиеся команды и команды с пробелом в начале
HISTCONTROL=ignoreboth
# Не запоминать дубликаты, и протые команды
export HISTIGNORE="&:ls:[bf]g:exit"
# Количество строк в памяти
HISTSIZE=1024
# Количество строк в файле .bash_history
HISTFILESIZE=10240
# Формат времени (вкл. запись timestamp)
HISTTIMEFORMAT='%d.%H.%y %H:%M:%S '
# Для мгновенной записи в историю
shopt -s histappend
PROMPT_COMMAND='history -a'
# Исправляем Глупые ошибки в написании
shopt -s cdspell
# многострочные команды будут записываться в одну строку
shopt -s cmdhist

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

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
# Usage: ex <archive_name>
ex () {
if [ -f $1 ] ; then
case $1 in
*.tar.bz2) tar xjf $1 ;;
*.tar.gz) tar xzf $1 ;;
*.bz2) bunzip2 $1 ;;
*.rar) rar x $1 ;;
*.gz) gunzip $1 ;;
*.tar) tar xf $1 ;;
*.tbz2) tar xjf $1 ;;
*.tgz) tar xzf $1 ;;
*.zip) unzip $1 ;;
*.Z) uncompress $1 ;;
*.7z) 7z x $1 ;;
*) echo "'$1' cannot be extracted via extract()" ;;
esac
else
echo "'$1' is not a valid file"
fi
}

# User specific aliases and functions
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ll='ls -lah'
alias ls='ls --color=auto'
alias l.='ls -d .* --color=auto'
alias ff='echo find ./ -type f -exec grep -i -H \"STRING\"  {} \\\;'

alias cd..='cd ..'
alias .3='cd ../../../'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
fi

# монтирование iso. общий синтаксис команды получается такой: mountiso [что] [куда]
alias mountiso='sudo mount -o loop -t iso9660'

# монтирование nrg. общий синтаксис команды получается такой: mountnrg [что] [куда]
alias mountnrg='mount -t udf,iso9660 -o loop,ro,offset=307200'

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


alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

alias sha1='openssl sha1'
alias bc='bc -l'
alias mkdir='mkdir -pv'

## Для раскраски diff'a надо поставить colordiff
#alias diff='colordiff'
alias mount='mount |column -t'
alias h='history'
alias j='jobs -l'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T'
alias nowdate='date +"%d-%m-%Y"'
alias ping='ping -c 5'

#Показываем открытые порты
alias ports='netstat -tulanp'

## Будим спящие компьютеры.
## не забываем менять mac-адрес на реальный адрес компьютера #
alias wakeupn01='/usr/bin/wakeonlan 00:11:32:11:15:FC'
alias wakeupn02='/usr/bin/wakeonlan 00:11:32:11:15:FD'
alias wakeupn03='/usr/bin/wakeonlan 00:11:32:11:15:FE'

# display all rules # 
alias iptlist='sudo /sbin/iptables -L -n -v --line-numbers'
alias iptlistin='sudo /sbin/iptables -L INPUT -n -v --line-numbers'
alias iptlistout='sudo /sbin/iptables -L OUTPUT -n -v --line-numbers'
alias iptlistfw='sudo /sbin/iptables -L FORWARD -n -v --line-numbers'
alias firewall=iptlist

# get web server headers # 
alias header='curl -I'

# do not delete / or prompt if deleting more than 3 files at a time # 
alias rm='rm -I --preserve-root'

# confirmation # 
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'

# Parenting changing perms on / # 
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

# update on one command 
alias update='sudo apt-get update && sudo apt-get dist-upgrade'

## Управляем веб-сервером.
## also pass it via sudo so whoever is admin can reload it without calling you # 
alias nginxreload='sudo /usr/local/nginx/sbin/nginx -s reload'
alias nginxtest='sudo /usr/local/nginx/sbin/nginx -t'
alias lightyload='sudo /etc/init.d/lighttpd reload'
alias lightytest='sudo /usr/sbin/lighttpd -f /etc/lighttpd/lighttpd.conf -t'
alias httpdreload='sudo /usr/sbin/apachectl -k graceful'
alias httpdtest='sudo /usr/sbin/apachectl -t && /usr/sbin/apachectl -t -D DUMP_VHOSTS'

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

## set some other defaults ## 
alias df='df -H' 
alias du='du -ch'

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"


## Memcached server status  ## 
#alias mcdstats='/usr/bin/memcached-tool 10.10.27.11:11211 stats' 
#alias mcdshow='/usr/bin/memcached-tool 10.10.27.11:11211 display'

## quickly flush out memcached server ## 
#alias flushmcd='echo "flush_all" | nc 10.10.27.11 11211'

## Remove assets quickly from Akamai / Amazon cdn ## 
#alias cdndel='/home/scripts/admin/cdn/purge_cdn_cache --profile akamai' 
#alias amzcdndel='/home/scripts/admin/cdn/purge_cdn_cache --profile amazon'
