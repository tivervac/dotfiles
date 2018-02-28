#!/bin/sh -e
# Credits to https://github.com/iambecomeroot/dotfiles/blob/master/bin/bin/lock

TMPBG=/tmp/screen_locked.png

rectangles=" "

SR=$(xrandr --query | grep ' connected' | grep -o '[0-9][0-9]*x[0-9][0-9]*[^ ]*')
for RES in $SR; do
  SRA=(${RES//[x+]/ })
  CX=$((${SRA[2]} + 25))
  CY=$((${SRA[1]} - 80))
  rectangles+="rectangle $CX,$CY $((CX+300)),$((CY-80)) "
done

escrotum $TMPBG && convert $TMPBG -scale 10% -scale 1000% -draw "fill black fill-opacity 0.4 $rectangles" $TMPBG

# Lock screen displaying this image.
i3lock \
    -i $TMPBG \
    --timepos="x-90:h-ch-20" \
    --datepos="tx+24:ty+25" \
    --clock --datestr "Type password to unlock..." \
    --insidecolor=00000000 --ringcolor=ffffffff --line-uses-inside \
    --keyhlcolor=d23c3dff --bshlcolor=d23c3dff --separatorcolor=00000000 \
    --insidevercolor=fecf4dff --insidewrongcolor=d23c3dff \
    --ringvercolor=ffffffff --ringwrongcolor=ffffffff --indpos="x+290:h-120" \
    --radius=20 --ring-width=3 --veriftext="" --wrongtext="" \
    --textcolor="ffffffff" --timecolor="ffffffff" --datecolor="ffffffff"

rm $TMPBG

# Turn the screen off after a delay.
sleep 60; pgrep i3lock && xset dpms force off
