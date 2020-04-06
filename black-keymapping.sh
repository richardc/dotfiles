#!/bin/sh
set -x
# black runs gnome, that means you need to tell gnome what your
# xkb-options are or it keeps smashing over them

# * Active settings:
# ** =caps:escape=
#    use capslock as an escape key, like on the old terminals where vi was born
# ** =altwin:swap_lalt_lwin=
#    swap left alt and win so it feels more like a mac.  lwin is roughly command
gsettings set org.gnome.desktop.input-sources xkb-options "['caps:escape,altwin:swap_lalt_lwin']"

