# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"                                  
# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)                              case "$TERM" in
#    xterm-color) color_prompt=yes;;
#esac

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

#if [ "$color_prompt" = yes ]; then
#    PS1='\[\033[01;32m\][\[\033[01;36m\]\u \[\033[01;32m\]> \[\033[01;36m\]\W\[\033[01;32m\]] \[\033[01;37m\]\$(git_branch)\[\033[01;32m\] → \[\033[00;39m\]'
#else
#    PS1='\[\033[01;32m\][\[\033[01;36m\]\u \[\033[01;32m\]> \[\033[01;36m\]\W\[\033[01;32m\]] \[\033[01;37m\]\$(git_branch)\[\033[01;32m\] → \[\033[00;39m\]'
#fi

unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
#case "$TERM" in
#xterm*|rxvt*)
#    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
##    ;;
#*)
#    ;;
#esac

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

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ~='cd ~'
alias Leander='cd ~/Leander'
alias md='mkdir -p'

# Vim
alias vim='/opt/vim80/bin/vim'
alias vi='/opt/vim80/bin/vim'
alias vimdiff='/opt/vim80/bin/vimdiff'

# Git
alias g='git'
alias gi='git init'
alias glg='git log'
alias glgg='git log --graph'
alias glggo='git log --graph --oneline --decorate'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'
alias gcm='git checkout master'
alias ga='git add'
alias gaa='git add --all'
alias gst='git status'
alias gc='git commit'
alias gcmsg='git commit -m'
alias gp='git push'
alias ggpush='git push origin $(git_current_branch)'
alias gf='git fetch'
alias gl='git pull'
alias ggpull='git pull origin $(git_current_branch)'
alias gm='git merge'
alias gcl='git clone'
alias gr='git remote'
alias gra='git remote add'
alias grv='git remote -v'

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
#if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
#    . /etc/bash_completion
#fi

# added by Anaconda3 4.4.0 installer
export "PATH=/home/leander/anaconda3/bin:$PATH"

function parse_git_dirty {
    local git_status=$(git status 2> /dev/null);
    if [[ "$git_status" != "" ]]; then
        local git_now;
        local git_status_head_two=$(git status | head -n2 | tail -n1);
        if [[ "$git_status_head_two" =~ Your\ branch\ is\ up-to-date ]]; then
            local git_status_head_three=$(git status | head -n3 | tail -n1);
            if [[ "$git_status_head_three" =~ nothing\ to\ commit ]]; then
                git_now="✓";
            elif [[ "$git_status_head_three" =~ Changes\ not\ staged ]]; then
                git_now='⚐';
            elif [[ "$git_status_head_three" =~ Changes\ to\ be\ committed ]]; then
                git_now='⚑';
            elif [[ "$git_status_head_three" =~ Untracked\ files ]]; then
                git_now="✚";
            fi
        elif [[ "$git_status_head_two" =~ Your\ branch\ is\ ahead ]]; then
            local git_status_head_four=$(git status | head -n4 | tail -n1);
            if [[ "$git_status_head_four" =~ nothing\ to\ commit ]]; then
                git_now="⦿";
            elif [[ "$git_status_head_four" =~ Changes\ not\ staged ]]; then
                git_now='⚐';
            elif [[ "$git_status_head_four" =~ Changes\ to\ be\ committed ]]; then
                git_now='⚑';
            elif [[ "$git_status_head_four" =~ Untracked\ files ]]; then
                git_now="✚";
            fi
        elif [[ "$git_status_head_two" =~ nothing\ to\ commit ]]; then
            git_now="✓";
        elif [[ "$git_status_head_two" =~ Changes\ not\ staged ]]; then
            git_now='⚐';
        elif [[ "$git_status_head_two" =~ Changes\ to\ be\ committed ]]; then
            git_now='⚑';
        elif [[ "$git_status_head_two" =~ Untracked\ files ]]; then
            git_now="✚";   
        fi
        echo "${git_now}";
    fi
}

function git_branch {
    ref=$(git symbolic-ref HEAD 2> /dev/null);
    local branch=$(git branch 2> /dev/null);
    local branch_echo;
    if [[ "$ref" != "" ]]; then
        branch_echo="("${ref#refs/heads/}"∣"$(parse_git_dirty)") ";
    elif [[ "$branch" != "" ]]; then
        branch=$(git branch 2> /dev/null | head -n1 | sed 's/* (HEAD detached at //g' | sed 's/)//g');
        branch_echo="("${branch}"∣"$(parse_git_dirty)") ";
    fi
    echo "${branch_echo}";
}

export PS1='\[\033[01;32m\][\[\033[01;36m\]\u \[\033[01;32m\]> \[\033[01;36m\]\W\[\033[01;32m\]] \[\033[01;35m\]$(git_branch)\[\033[01;32m\]➜ \[\033[00;39m\]'
