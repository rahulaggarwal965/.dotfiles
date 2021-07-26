#!/bin/zsh

# Adds scripts folder to path
export PATH="$PATH:$(du "$HOME/.local/bin/" | cut -f2 | paste -sd ':')"

# Default programs
export EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL="st"
export PAGER="less"
export FILE="lf"

# Clean up home directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

export LESSHISTFILE="-"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Other program settings
export FZF_DEFAULT_OPTS="--reverse --height 40%"
export FZF_DEFAULT_COMMAND="fd --type f --hidden --exclude .git --exclude MATLAB"
