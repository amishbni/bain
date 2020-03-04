#!/bin/bash

create_and_set() {
	orig=$1
	perc=$2
	status=$3
	size=`identify -format '%wx%h' $orig`

	if [[ "$status" == "Charging" ]]; then
		color='#FFFF00'
	else
		if [ "$perc" -ge 30 ]; then
			color='#5BC236'
		else
			color='#BF131C'
		fi
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

file=$1
battery_path=$(find_battery_path)
last_changed=`< $battery_path/capacity`
last_status=`< $battery_path/status`
create_and_set $file $last_changed $last_status

while true
do
	current=`< $battery_path/capacity`
	_status=`< $battery_path/status` # can not use $status because it is reserved

	if [[ "$last_changed" != "$current" ]] || [[ "$_status" != "$last_status" ]]
	then
		create_and_set $file $current $_status
		last_changed=$current
		last_status=$status
	fi
	sleep 5
done
