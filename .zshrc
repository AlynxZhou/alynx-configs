#!/bin/zsh

# 常见变量
export LANG=en_US.UTF-8
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PAGER="less -irf"
export EDITOR="/usr/bin/emacs"
# export VISUAL="/usr/bin/atom"
# export ARCHFLAGS="-arch x86_64"
# export SSH_KEY_PATH="~/.ssh/rsa_id"
export ANDROID_HOME=/opt/android-sdk

# 设置按键风格（`-e` Emacs `-v` Vi）
bindkey -e
# 设置上下方向键自动搜索历史
bindkey "\e[A" up-line-or-search
bindkey "\e[B" down-line-or-search
# 设置左右方向键
bindkey "\e[C" forward-char
bindkey "\e[D" backward-char
# Alt + Left / Right
bindkey "\e[1;3C" forward-word
bindkey "\e[1;3D" backward-word
# Home / End
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
# PageUp / PageDown
bindkey "\e[5~" up-line-or-history
bindkey "\e[6~" down-line-or-history
# 添加 sudo
function add-sudo() {
	[[ -z ${BUFFER} ]] && zle up-history
	[[ ${BUFFER} != sudo\ * ]] && BUFFER="sudo ${BUFFER}"
	# 光标移动到行末
	zle end-of-line
}
zle -N add-sudo
# 绑定添加 sudo 快捷键（双击 Esc）
bindkey "\e\e" add-sudo

# 设置历史文件
HISTFILE=~/.zhistory
# 历史文件体积
HISTSIZE=1000
# 历史条数
SAVEHIST=1000

# 自动修正
setopt correct
# 多个 zsh 共享命令历史记录
setopt append_history
setopt share_history
# 如果连续输入的命令相同，历史纪录中只保留一个
setopt hist_ignore_dups
# 为历史纪录中的命令添加时间戳
setopt extended_history
# 启用 cd 命令的历史纪录，cd -[TAB]进入历史路径
setopt auto_pushd
# 相同的历史路径只保留一个
setopt pushd_ignore_dups
# 在命令前添加空格，不将此命令添加到纪录文件中
setopt hist_ignore_space
# 加强版通配符
setopt extended_glob
# 在后台运行命令时不调整优先级
setopt no_bg_nice
# 禁用终端响铃
unsetopt beep
# 扩展路径
# /v/c/p/p => /var/cache/pacman/pkg
setopt complete_in_word
# 允许在提示符内使用函数
setopt prompt_subst
# 以下字符视为单词的一部分
WORDCHARS='*?_-[]~=&;!#$%^(){}<>'
setopt auto_list
setopt auto_menu
# 开启此选项，补全时会直接选中菜单项
# setopt menu_complete

# 颜色支持
autoload -U colors && colors

# 加载自动补全
zstyle :compinstall filename "/home/alynx/.zshrc"
autoload -Uz compinit && compinit
# 自动补全选项
zstyle ":completion:*" rehash true
zstyle ":completion:*" verbose yes
zstyle ":completion:*" menu select
zstyle ":completion:*:*:default" force-list always
zstyle ":completion:*" select-prompt '%SSelect:  lines: %L  matches: %M  [%p]'
zstyle ":completion:*:match:*" original only
zstyle ":completion::prefix-1:*" completer _complete
zstyle ":completion:predict:*" completer _complete
zstyle ":completion:incremental:*" completer _complete _correct
zstyle ":completion:*" completer _complete _prefix _correct _prefix _match _approximate

# 路径补全
zstyle ":completion:*" expand "yes"
zstyle ":completion:*" squeeze-slashes "yes"
zstyle ":completion::complete:*" "\\"

# 彩色补全菜单
export ZLSCOLORS=$LS_COLORS
zmodload zsh/complist
zstyle ":completion:*" list-colors ${(s.:.)LS_COLORS}

# 修正大小写
zstyle ":completion:*" matcher-list "" "m:{a-zA-Z}={A-Za-z}"

# 错误校正
zstyle ":completion:*" completer _complete _match _approximate
zstyle ":completion:*:match:*" original only
zstyle ":completion:*:approximate:*" max-errors 1 numeric

# 补全类型提示分组
zstyle ":completion:*:matches" group "yes"
zstyle ":completion:*" group-name ""
zstyle ":completion:*:options" description "yes"
zstyle ":completion:*:options" auto-description "%d"
zstyle ":completion:*:descriptions" format $'%F{cyan}%B-- %d --%b%f'
zstyle ":completion:*:messages" format $'%F{purple}%B-- %d --%b%f'
zstyle ":completion:*:warnings" format $'%F{red}%B-- No Matches Found --%b%f'
zstyle ":completion:*:corrections" format $'%F{green}%B-- %d (errors: %e) --%b%f'

# kill 补全
zstyle ":completion:*:*:kill:*:processes" list-colors "=(#b) #([0-9]#)*=0=01;31"
zstyle ":completion:*:*:kill:*" menu yes select
zstyle ":completion:*:*:*:*:processes" force-list always
zstyle ":completion:*:processes" command "ps -au${USER}"

# cd ~ 补全顺序
zstyle ":completion:*:-tilde-:*" group-order "named-directories" "path-directories" "users" "expand"

# 常见命令别名
alias l="ls -alh --color"
alias la="ls -a --color"
alias ll="ls -lh --color"
alias zshconfig="${EDITOR} ~/.zshrc"
alias oh-my-zsh="source ~/.zshrc"
alias ee="emacsclient -c -a """
alias ec="emacsclient -nw -c -a """
alias gcc11="gcc -std=c11"
alias clang11="clang11 -std=c11"
alias disabletouch="sudo modprobe -r usbhid"
alias enabletouch="sudo modprobe usbhid"
alias 速冻="sudo"
alias vi="nvim"

# For close nvidia card via bbswitch due to a bug in bumblebee now.
#alias nclose="sudo rmmod nvidia_modeset nvidia && sudo tee /proc/acpi/bbswitch <<< OFF"

# For Wine 32.
#export WINEARCH=win32
#export WINEPREFIX=~/win32yulian
#export WINEPREFIX=~/.winetim

# For turn ibus-rime from v to h.
#alias rime-hor="gsettings set org.freedesktop.ibus.panel lookup-table-orientation 0"

# For thefuck.
#eval $(thefuck --alias)

# 提示符设置
## Last command result.
# True is nothing. False is red `!`.
local result_status=%(?::"%F{red}%B !%b%f")

## OS detection.
function os_status() {
	if [[ -n ${SSH_CONNECTION} ]]; then
		echo "(ssh)"$(command uname)
	else
		echo $(command uname)
	fi
}

## Battery.
# Warning: For the prompt will only refresh by pressing <ENTER>, the battery showing maybe not right, also the time and date.
function battery_status() {
	echo $(command cat /sys/class/power_supply/BAT0/capacity 2> /dev/null)
}

## Git status.
# If there is a git repo, show status.
function git_status() {
	local ref=$(command git symbolic-ref HEAD 2> /dev/null)
	# Check for git repo.
	if [[ -n $(command git rev-parse --short HEAD 2> /dev/null) ]]; then
		# Check for dirty or not.
		if [[ -n $(command git status --porcelain --ignore-submodules=dirty 2> /dev/null | tail -n1) ]]; then
			echo " <%F{cyan}"${ref#refs/heads/}"%f%F{yellow}*%f>"
		else
			echo " <%F{cyan}"${ref#refs/heads/}"%f>"
		fi
	fi
}

## Background jobs.
function jobs_status() {
	local JOBS=$(jobs -l | wc -l)
	if [[ ${JOBS} != "0" ]]; then
		echo " (%F{green}"${JOBS}"&%f)"
	fi
}

## Prompt.
# Here is the LEFT PROMPT containing username `%n`, hostname `%m`, directory `%~`, git info `$(git_status)`, result status `${result_status}`, jobs `$(jobs_status)` and the `%#`.
PROMPT='[%F{red}%n%f@%F{cyan}%m%f:%F{yellow}%3~%f]$(git_status)$(jobs_status)${result_status} %# '
# Here is the RIGHT PROMPT containing battery `$(battery_status)`, os `$(os_status)`, jobs `$(jobs_status)`, time `%D{%H:%M:%S}` and date `%D{%Y-%m-%d}`.
#RPROMPT='%F{244}%f%K{244}%F{235}$(battery_status)%k%K{244}%f%F{254}%f%F{235}$(os_status)$(jobs_status)%f%F{246}%f%k%K{246}%F{235}%D{%H:%M:%S}%f%F{254}%f%F{235}%D{%Y-%m-%d}%f%F{236}%f%k'

# 终端模拟器标题
function precmd() {
	print -Pn '\e]0;%n@%m:%~\a'
}
function preexec() {
	print -Pn '\e]0;${1}\a'
}

# 语法高亮插件
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# 命令提示插件
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
