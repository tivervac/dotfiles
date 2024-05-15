#!/bin/bash
# Thanks to noctua for the base script
# Thanks to Iasoon for the advanced ssh config parsing
set -e

sshhost="flesje"
fles="http://t2-wan.be"

# Find ssh username
user=$(
    # Join config entries
    sed -n '$!{/host /I!{H;d}};x;s/\n/ /g;p' $HOME/.ssh/config  |
    # Extract user/host combinations
    grep -i 'user' | tr -s ' ' ' ' |
    sed 's/^.*host \([^ \t]\+\).*user \([^ \t]\+\).*$/\1 \2/I' |
    # Find user
    (grep "^$sshhost" || echo $USER) | cut -d ' ' -f 2
    )

file="$(mktemp XXXXXX.png)"
escrotum $* "$file"
chmod 644 $file
scp -p $file $sshhost:~/images/
rm "$file"
url="$fles/~$user/$file"
notify-send "Screenshot uploaded to $url"
echo "$url" | xsel -bi
