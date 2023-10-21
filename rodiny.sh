#!/bin/bash

if (( $# != 1 )); then
    >&2 echo "Illegal number of arguments"
    echo "USAGE: $0 <webhook url>"
    exit 1
fi

: "${ASSASSIN_ROOT:=.}"
cd $ASSASSIN_ROOT
source assassin.conf

: "${HXSELECT:=hxselect}"

WEBHOOKURL="$1"

curl -sS -L -b "$COOKIES_FILE" "http://brno.assassin.cz/zebricek-rodin" | \
$HXSELECT -s '\n' "table tr td:first-child, table tr td:nth-child(2) a" | \
sed 's/<td>\(.*\)<\/td>/\1/' | \
sed 's/<a.*>\(.*\)<\/a>/\1/' | \
while read FAMILY && read NAME
do
    echo -n "$FAMILY - $NAME\n"
done | curl -sS -X POST -H "Content-Type: application/json" -d \
    "{\"content\": null,
      \"embeds\": [{
      \"title\": \"Žebříček rodin $(date +%F | tr -d "\n")\",
          \"description\": \"$(cat -)\",
          \"color\": null
      }],
      \"attachments\": [] }" $WEBHOOKURL

