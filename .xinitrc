#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# Disable beep
xset -b

if [ -f ~/.Xresources ]; then
    xrdb -merge ~/.Xresources
fi

urxvtd -q -f -o

feh --bg-scale ~/.wallpaper/totoro.png
exec i3
