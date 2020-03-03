#!/bin/bash

file=$1
last_changed=`< /sys/class/power_supply/BAT0/capacity`
$HOME/bain/create.sh $file $last_changed

while true
do
	current=`< /sys/class/power_supply/BAT0/capacity`

	if [[ "$last_changed" != "$current" ]]
	then
		$HOME/bain/create.sh $file $current
		last_changed=$current
	fi
	sleep 5
done
