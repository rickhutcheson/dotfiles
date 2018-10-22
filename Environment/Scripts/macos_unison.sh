#!/bin/sh
PATH=/usr/local/bin:/usr/local/sbin:~/bin:/usr/bin:/bin:/usr/sbin:/sbin

/usr/local/bin/unison -ui text -batch Dropbox

if [ $? -eq 0 ]; then
    exit 0
else
    /usr/bin/mail -s "Unison Sync Failed" rick <<< "unison sync failed at $(date)"
fi
