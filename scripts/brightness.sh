#!/bin/bash

step=2%
notificationTimeout=1000
keyboardDevice="asus::kbd_backlight"

get_screen_brightness() {
  brightness=$(brightnessctl g -P)
  echo $brightness
}

notify_user() {
  notify-send -e -u low -t $notificationTimeout -h string:x-canonical-private-synchronous:brightness "Brightness: $(get_screen_brightness)%" -i "$HOME/.themes/wallust/icons/brightness-$1.svg"
}

inc_screen_brightness() {
  brightnessctl set +$step
  notify_user plus
}

dec_screen_brightness() {
  brightnessctl set $step-
  notify_user minus
}

toggle_screen() {
  brightness=$(get_screen_brightness)

  if [[ $brightness == 0 ]]; then
    brightnessctl --restore
  else
    brightnessctl --save
    brightnessctl set 0%
  fi

  notify_user empty
}

# Execute accordingly
if [[ "$1" == "--get" ]]; then
  get_screen_brightness
elif [[ "$1" == "--inc" ]]; then
  inc_screen_brightness
elif [[ "$1" == "--dec" ]]; then
  dec_screen_brightness
elif [[ "$1" == "--toggle-screen" ]]; then
  toggle_screen
elif [[ "$1" == "--inc-keyboard" ]]; then
  brightnessctl -d $keyboardDevice set 1+
elif [[ "$1" == "--dec-keyboard" ]]; then
  brightnessctl -d $keyboardDevice set 1-
else
  get_screen_brightness
fi
