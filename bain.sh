#!/bin/bash

create_and_set() {
	orig=$1
	perc=$2
	size=`identify -format '%wx%h' $orig`

	if [ "$perc" -ge 30 ]; then
		color='#5BC236'
	else
		color='#BF131C'
	fi
	convert $orig -gravity South -crop x$perc% -fuzz 50% -fill $color -opaque '#8FBCBB' -background transparent -extent $size out.png

	convert $orig out.png -gravity Center -composite -background '#2E3440' -gravity Center -extent 3840x2160 background.png

	feh --no-fehbg --bg-scale background.png
}

find_battery_path() {
	local file
	for file in /sys/class/power_supply/*; do
	    read power_supply < "$file"/type
	    if [ "$power_supply" = "Battery" ]; then
		declare -r battery_found=1
		echo "$file"
		break
	    fi
	done

	if [ -z "$battery_found" ]; then
		echo "Couldn't find battery"
		exit 1
	fi

}

SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
file="$SCRIPTPATH/images/$1.png"
battery_path=$(find_battery_path)
last_changed=`< $battery_path/capacity`
create_and_set $file $last_changed

while true
do
	current=`< $battery_path/capacity`

	if [[ "$last_changed" != "$current" ]]
	then
		echo $current
		create_and_set $file $current
		last_changed=$current
	fi
	sleep 5
done
