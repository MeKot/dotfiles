#!/bin/bash

hider='pgrep -f polybar-autohide'
kill hider
killall polybar
# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done
killall compton
compton -b
# compton --config ~/dotfiles/compton.conf -b
polybar -c ~/.config/polybar/config default &
exec /home/admin/dotfiles/polybar/polybar-autohide &

