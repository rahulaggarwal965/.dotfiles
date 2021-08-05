#!/bin/zsh

# Adds scripts folder to path
export PATH="$PATH:$(du "$HOME/.local/bin/" | cut -f2 | paste -sd ':')"

# Default programs
export EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL="st"
export BROWSER="brave"
export READER="zathura"
export IMAGE="sxiv"
export VIDEO="mpv"
export PAGER="less"
export MANPAGER="nvim +Man!"
export FILE="lfimg"
export WM="bspwm"

# Clean up home directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"

export LESSHISTFILE="-"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0"
export PULSE_COOKIE="$XDG_CONFIG_HOME/pulse/cookie"
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/pass"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export GOPATH="$XDG_CONFIG_HOME/go"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
export PYLINTHOME="$XDG_CACHE_HOME/pylint"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export MATLAB_LOG_DIR="$XDG_CACHE_HOME/matlab"

# Other program settings
export SUDO_ASKPASS="$HOME/.local/bin/utils/askpass-dmenu"
export _JAVA_AWT_WM_NONREPARENTING=1
export FZF_DEFAULT_OPTS="--reverse --height 40%"
export FZF_DEFAULT_COMMAND="fd --type f --hidden --exclude .git --exclude MATLAB"

# Java Classpath
export CLASSPATH=.:/usr/share/java/junit.jar:/usr/share/java/hamcrest-core.jar

if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
    sudo /usr/bin/prime-switch
    exec ssh-agent startx "$XDG_CONFIG_HOME/X11/xinitrc" -- -keeptty &> ~/.cache/xorg.log
fi
