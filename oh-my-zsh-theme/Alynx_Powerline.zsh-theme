#!/bin/zsh
#-*- coding: utf-8 -*-


# Filename: Alynx_Powerline.zsh-theme
# Created by 请叫我喵 Alynx.
# alynx.zhou@gmail.com, http://alynx.xyz/


##
# I wrote this to satisfy myself, for I haven't found a proper theme.
# My theme has three laws:
# 1. It must be beautiful and single-line.
# 2. It only has useful functions. For example, basic prompt (user@hostname:directory %), git prompt, result status, background jobs, battery, time and date.
# 3. It must be simple. Some themes have too many variables and functions. I won't.
##
# To create a powerline style theme, use `%K{color}` to set a background color, `%k` to stop a background color.
# `%F{color}` for a foreground color, `%f` to stop.
# `%B` to bold some text and `%b` to stop.
# When a background color stop, a `%K{next_background_color}%F{pervious_background_color}%f` can create a powerline style.
# I got the `   ` from vim-powerline, you also need a powerline-patched font to display them.
# Use `function some_function(){}` to build a function.
##


## OS detection.
if [[ -z "${KERNEL}" ]]; then
	local KERNEL=$(uname)
fi

if [[ -n "${SSH_CONNECTION}" ]]; then
	local OS="(ssh)${KERNEL}"
else
	local OS="${KERNEL}"
fi


## Last command result.
# True is green. False is red.
local result_status="%(?:%F{green}%B ➜ %b%f:%F{red}%B ➜ %f%b%s)"


## Git status.
# If the directory is a git repo, the function git_prompt_info() (built-in) will show $ZSH_THEME_GIT_PROMPT_PREFIX (in mine is `git:(`) first.
# And then the branch now.
# If dirty, it will show $ZSH_THEME_GIT_PROMPT_DIRTY (mine is `*)`).
# It will show $ZSH_THEME_GIT_PROMPT_CLEAN (`)`) in a clean repo.
# Last is $ZSH_THEME_GIT_PROMPT_SUFFIX.
# If the directory is not a repo, it will only show $ZSH_THEME_GIT_PROMPT_SUFFIX.
ZSH_THEME_GIT_PROMPT_PREFIX="%F{blue}%Bgit:(%F{red}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%b%f"
ZSH_THEME_GIT_PROMPT_DIRTY="%F{yellow}*%F{blue})"
ZSH_THEME_GIT_PROMPT_CLEAN="%F{blue})"


## Background jobs.
function jobs_status() {
	local JOBS=$(jobs -l | wc -l)
	if [[ $JOBS == 0 ]]; then
		echo ''
	else
		echo ':'$JOBS"%F{red}&%f"
	fi
}


## Battery.
# Warning: For the prompt will only refresh by pressing <ENTER>, the battery showing maybe not right, also the time and date.
function battery_status() {
	local BATTERY=$(cat /sys/class/power_supply/BAT0/capacity)
	echo ${BATTERY}"%F{yellow}%B⚡%b%f"
}


## Prompt.
# Note git_prompt_info() won't work with double quote.
# Here is the LEFT PROMPT containing username `%n`, hostname `%m`, directory `%~`, git info `$(git_prompt_info)`, result status `${result_status}` and the `%#`.
PROMPT='%K{238}%F{236}%f%F{red}%n%f@%F{cyan}%m%F{234}%f:%F{yellow}%~%f%k%K{240}%F{238}%f$(git_prompt_info)%k%K{242}%F{240}%f${result_status}%k%F{242}%f %# '
# Here is the RIGHT PROMPT containing battery `$(battery)`, OS `${OS}`, jobs `$(jobs_status)`, time `%D{%H:%M:%S}` and date `%D{%Y-%m-%d}`.
if [[ -e /sys/class/power_supply/BAT0/capacity ]]; then
	RPROMPT='%F{244}%f%K{244}%F{235}$(battery_status)%k%K{244}%f%F{254}%f%F{235}${OS}$(jobs_status)%f%F{246}%f%k%K{246}%F{235}%D{%H:%M:%S}%f%F{254}%f%F{235}%D{%Y-%m-%d}%f%F{236}%f%k'
else
	RPROMPT='%F{244}%f%K{244}%F{235}${OS}$(jobs_status)%f%F{246}%f%k%K{246}%F{235}%D{%H:%M:%S}%f%F{254}%f%F{235}%D{%Y-%m-%d}%f%F{236}%f%k'
fi
