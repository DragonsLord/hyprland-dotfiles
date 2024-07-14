#!/bin/bash

temp_dir=$"/tmp"
wallpaper_dir="$HOME/.desk-env"
wallpaper_name="wallpaper.png"
wallpaper_path="$wallpaper_dir/$wallpaper_name";

init_wallpaper() {
    if [ ! -f $wallpaper_path ]; then
        echo "Wallpaper file not found!"
        return
    fi

    swaybg -i "$wallpaper_path"
    wallust run "$wallpaper_path"
}

set_wallpaper() {
    selected_wallpaper_path=$1
    echo "setting wallpaper: $selected_wallpaper_path"
    # [WORKAROUND] Copy to tmp dir to avoid readonly filesystem issue
    cp $selected_wallpaper_path "$temp_dir/wallpaper"
    mogrify -format png "$temp_dir/wallpaper"
    rm "$temp_dir/wallpaper"
    mv "$temp_dir/wallpaper.png" $wallpaper_path
}

reload_wallpaper() {
    self_path="$(pwd)/$0"

    killall swaybg
    hyprctl keyword exec "$self_path --init"
}

reload_waybar() {
    killall waybar
    hyprctl keyword exec "waybar"
}


# Execute accordingly
if [[ "$1" == "--init" ]]; then
	init_wallpaper
elif [[ "$1" == "--set" ]]; then
	set_wallpaper $2
    if [[ ! "$3" == "--no-ctl" ]]; then 
        reload_wallpaper $0
        reload_waybar
    else
        killall swaybg
        init_wallpaper

        killall waybar
        waybar
    fi
else
    echo "Usage: --init, --set wallpaper_path"	
fi
