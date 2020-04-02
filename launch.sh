#!/bin/bash

# hider='pgrep -f polybar-autohide'
# kill $hider
# killall polybar
# Wait until the processes have been shut down
# while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done
killall compton
compton --config ~/dotfiles/compton.conf -b
# nohup polybar -c ~/.config/polybar/config default &> /dev/null &
# exec /home/admin/dotfiles/polybar/polybar-autohide &> /dev/null &
