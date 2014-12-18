#!/bin/bash
# Thanks to noctua

fles="WEBSITE"
file="$(mktemp XXXXXX.png)"
scrot $* "$file"
chmod 755 $file
scp -p $file flesje:~/Pictures/
rm "$file"
url="$fles":8080/"$file"
notify-send "Screenshot uploaded to $url"
echo "$url" | xclip -sel c
