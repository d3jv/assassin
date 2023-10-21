#!/bin/bash

source ../assassin.conf

while IFS=$'\n' read -r LINE; do
  NAME=$(echo "$LINE" | cut -d';' -f1);
  PHOTO=$(echo "$LINE" | cut -d';' -f2);
  convert -size 188x30 xc:lightblue -pointsize 15 -fill darkred -draw "text 0,25 '$NAME'" tmp1.png;
  curl -sS -L -b ../"$COOKIES_FILE" "$PHOTO" > tmp2.png;
  convert tmp2.png tmp1.png -append "$NAME.png";
  rm tmp*.png;
done < $1

