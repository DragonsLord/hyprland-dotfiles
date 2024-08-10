#!/bin/bash

step=2%
limit=1.2
audioSink=@DEFAULT_AUDIO_SINK@
notificationTimeout=1000

#TODO: add notification icons

get_volume() {
  volume=$(wpctl get-volume $audioSink)
  echo $volume
}

notify_user() {
  notify-send -e -u low -t $notificationTimeout -h string:x-canonical-private-synchronous:volume "$(get_volume)" -i "$HOME/.themes/wallust/icons/volume-$1.svg"
}

inc_volume() {
  wpctl set-volume -l $limit $audioSink $step+
  notify_user plus
}

dec_volume() {
  wpctl set-volume -l $limit $audioSink $step-
  notify_user minus
}

toggle_mute() {
  wpctl set-mute $audioSink toggle
  notify_user off
}

# Execute accordingly
if [[ "$1" == "--get" ]]; then
  get_volume
elif [[ "$1" == "--inc" ]]; then
  inc_volume
elif [[ "$1" == "--dec" ]]; then
  dec_volume
elif [[ "$1" == "--toggle-mute" ]]; then
  toggle_mute
else
  get_volume
fi
