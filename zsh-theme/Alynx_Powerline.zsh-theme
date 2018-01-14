#!/bin/zsh
#-*- coding: utf-8 -*-

# Filename: Alynx_Powerline.zsh-theme
# Created by 喵Alynx.
# alynx.zhou@gmail.com, http://alynx.xyz/.

# I wrote this to satisfy myself, for I haven't found a proper theme.
# My theme has three laws:
# 1. It must be beautiful and single-line.
# 2. It only has useful functions. For example, basic prompt (user@hostname:directory %), git status, result status, background jobs, battery, time and date.
# 3. It must be simple. Some themes have too many variables and functions. I won't.
# To create a powerline style theme, use `%K{color}` to set a background color, `%k` to stop a background color.
# `%F{color}` for a foreground color, `%f` to stop.
# `%B` to bold some text and `%b` to stop.
# When a background color stop, a `%K{next_background_color}%F{pervious_background_color}%f` can create a powerline style.
# I got the `   ` from vim-powerline, you also need a powerline-patched font to display them.
# Use `function some_function(){}` to build a function.
# Use single quote when you don't want a varible to be evaluation while setting.

## Last command result.
# True is nothing. False is red `!`.
local result_status=%(?::"%F{red}%B!%b%f")

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
			echo "%F{116}git%f:%F{203}"${ref#refs/heads/}"%f%F{229}*%f"
		else
			echo "%F{116}git%f:%F{203}"${ref#refs/heads/}"%f"
		fi
	fi
}

## Background jobs.
function jobs_status() {
	local JOBS=$(jobs -l | wc -l)
	if [[ ${JOBS} != "0" ]]; then
		echo ":"${JOBS}"&"
	fi
}

## Prompt.
# Here is the LEFT PROMPT containing username `%n`, hostname `%m`, directory `%~`, git info `$(git_status)`, result status `${result_status}`, jobs `$(jobs_status)` and the `%#`.
PROMPT='%K{238}%F{236}%f%F{red}%n%f@%F{cyan}%m%F{234}%f:%F{yellow}%~%f%k%K{240}%F{238}%f$(git_status)%k%K{242}%F{240}%f${result_status}$(jobs_status)%k%F{242}%f %# '
# Here is the RIGHT PROMPT containing battery `$(battery_status)`, os `$(os_status)`, jobs `$(jobs_status)`, time `%D{%H:%M:%S}` and date `%D{%Y-%m-%d}`.
#RPROMPT='%F{244}%f%K{244}%F{235}$(battery_status)%k%K{244}%f%F{254}%f%F{235}$(os_status)$(jobs_status)%f%F{246}%f%k%K{246}%F{235}%D{%H:%M:%S}%f%F{254}%f%F{235}%D{%Y-%m-%d}%f%F{236}%f%k'
