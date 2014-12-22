#!/bin/bash
# Thanks to noctua
set -e

sshuser="flesje"
fles="http://flashyoshi.me"
user=$(cat ~/.ssh/config | sed 's/^ \+//' | sed ':a;N;$!ba;s/\(.\)\n/\1 /g' | grep $sshuser | sed 's/.*User \([^ ]*\) .*/\1/')
file="$(mktemp XXXXXX.png)"
scrot $* "$file"
chmod 755 $file
scp -p $file $sshuser:~/images/
rm "$file"
url="$fles":8080/~"$user"/images/"$file"
notify-send "Screenshot uploaded to $url"
echo "$url" | xclip -sel c
