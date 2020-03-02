#!/bin/bash

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

feh --bg-scale background.png
