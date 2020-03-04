#!/bin/bash

create_and_set() {
	orig=$1
	perc=$2
	size=`identify -format '%wx%h' $orig`

	if [ "$perc" -ge 30 ]; then
		color=$COLOR_CHARGE
	else
		color=$COLOR_UNCHARGE
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

cat_help() {
		cat <<EOF
Usage: ./bain.sh [-h] [-b BATTERY] [-c COLOR_CHARGE] [-u COLOR_UNCHARGE] IMAGE

  -h, --help                        print this message and exits
  -b, --battery BATTERY             the battery of the computer, if not set the programm will try to find it automatically
  -c, --charge COLOR_CHARGE         color for charge battery, defualt #5BC236
  -u, --uncharge COLOR_UNCHARGE     color for uncharge battery, defualt #BF131C
  -r, --refresh                     refresh speed, defualt 5 seconds
  IMAGE                             the image to use for the background
EOF
		exit
}

REFRESH=5
COLOR_CHARGE='#5BC236'
COLOR_UNCHARGE='#BF131C'

while [ "$#" -gt 0 ]; do
	case "$1" in
		-h|--help) cat_help; shift;;
		-b|--battery) battery_path="$2"; shift 2;;
		-c|--charge) COLOR_CHARGE="$2"; shift 2;;
		-u|--uncharge) COLOR_UNCHARGE="$2"; shift 2;;
		-r|--refresh) REFRESH="$2"; shift 2;;
		*) file="$HOME/bain/images/$1.png"; shift 1;;
	esac
done

[ -z "$battery_path" ] && battery_path=$(find_battery_path)
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
	sleep $REFRESH
done
