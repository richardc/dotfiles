# Settings for theme-bobthefish
#  https://github.com/oh-my-fish/theme-bobthefish
#
# No custom fonts
set -g theme_powerline_fonts no

# Newline cursor
set -g theme_newline_cursor yes
set -g theme_newline_prompt '$ '

# Color scheme
set -g theme_color_scheme base16


## FZF
# make fzf respect ctrl-k to feel more like bash/zsh's reverse-i-search
export FZF_DEFAULT_OPTS='--bind ctrl-k:kill-line'

## General settings
#
# NixOS defaults you to nano
export EDITOR=vim
