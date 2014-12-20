#!/bin/bash
# Thanks to noctua
set -e

fles="http://flashyoshi.me"
file="$(mktemp XXXXXX.png)"
scrot $* "$file"
chmod 755 $file
scp -p $file flesje:~/images/
rm "$file"
url="$fles":8080/~flashyoshi/images/"$file"
notify-send "Screenshot uploaded to $url"
echo "$url" | xclip -sel c
