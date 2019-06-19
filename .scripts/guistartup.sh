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

if [ -f ~/.Xresources ]; then
    xrdb -merge ~/.Xresources
fi

export XDG_CURRENT_DESKTOP=Budgie:GNOME
exec budgie-desktop
#exec i3
# Put beep volume to zero, don't disable to allow for
# visual bleep
xset b 0

urxvtd -f -o

#feh --bg-scale ~/.wallpaper/Sigasi.png
numlockx on
