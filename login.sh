#!/bin/bash

if (( $# != 1 )); then
    >&2 echo "Illegal number of arguments"
    echo "USAGE: $0 <username>"
    exit 1
fi

: "${ASSASSIN_ROOT:=.}"
cd $ASSASSIN_ROOT
source assassin.conf

curl -sS -L --cookie-jar "$COOKIES_FILE" --form password=$(cat "$PASSWORD_FILE") --form username="$0" http://brno.assassin.cz/?do=loginForm-form-submit > /dev/null

