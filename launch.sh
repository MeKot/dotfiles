#!/bin/bash

hider = 'pgrep -f polybar-autohide'
kill hider
killall polybar
killall compton
compton --config ~/dotfiles/compton.conf -b
polybar -c ~/.config/polybar/config default
./~/dotfiles/polybar/polybar-autohide

