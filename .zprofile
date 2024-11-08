#!/bin/zsh

# Adds scripts folder to path
export PATH="$PATH:$(du "$HOME/.local/bin/" | cut -f2 | paste -sd ':')"

# Default programs
export EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL="alacritty"
export BROWSER="brave"
export READER="zathura"
export IMAGE="sxiv"
export VIDEO="mpv"
export PAGER="less"
export MANPAGER="nvim +Man!"
export FILE="lfimg"
export WM="awesome"

# Clean up home directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"

# Default cleanup
export LESSHISTFILE="-"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0"
export PULSE_COOKIE="$XDG_CONFIG_HOME/pulse/cookie"
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"

# Machine specific cleanup
export GOPATH="$XDG_CONFIG_HOME/go"
export IPYTHONDIR="$XDG_CONFIG_HOME/jupyter"
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"
export TEXMFHOME="$XDG_DATA_HOME/texmf"
export TEXMFVAR="$XDG_CACHE_HOME/texlive/texmf-var"
export TEXMFCONFIG="$XDG_CONFIG_HOME/texlive/texmf-config"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
export TERMINFO="$XDG_DATA_HOME/terminfo"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"

# Other program settings
export SUDO_ASKPASS="$HOME/.local/bin/utils/askpass-dmenu"
export SSH_ASKPASS="$HOME/.local/bin/utils/askpass-dmenu"
export _JAVA_AWT_WM_NONREPARENTING=1
export FZF_DEFAULT_OPTS="--reverse --height 40%"
export FZF_DEFAULT_COMMAND="fd --type f --hidden -L --exclude .git"

# nix
if [ -f "$XDG_STATE_HOME/nix/profiles/profile/etc/profile.d/nix.sh" ]; then
    source "$XDG_STATE_HOME/nix/profiles/profile/etc/profile.d/nix.sh"
    export LOCALE_ARCHIVE=/usr/lib/locale/locale-archive
fi

if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
    exec ssh-agent startx "$XDG_CONFIG_HOME/X11/xinitrc" -- -keeptty &> ~/.cache/xorg.log
fi
