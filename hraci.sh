#!/bin/bash

: "${ASSASSIN_ROOT:=.}"
cd $ASSASSIN_ROOT
source assassin.conf

: "${HXSELECT:=hxselect}"

if (( $# != 1 )); then
    >&2 echo "Illegal number of arguments"
    echo "USAGE: $0 <webhook url>"
    exit 1
fi

WEBHOOKURL="$1"

DATADIR=.hraci_data
mkdir $DATADIR 2> /dev/null
cd $DATADIR

curl -sS -L -b ../"$COOKIES_FILE" "http://brno.assassin.cz/zebricek-hracu/" | \
$HXSELECT -s '\n' "table tr td:first-child, h3" | \
sed 's/<td>\(.*\)<\/td>/\1/' | \
sed 's/  //g' | \
sed 's/<[\/]*h3>/**/g' | \
sed 's/<.*>//g' | \
grep -v '^$' > .hraci_current

count=0
output_file="/dev/null"

touch .hraci_1 .hraci_2 .hraci_3
mv ".hraci_1" .hraci_1.prev
mv ".hraci_2" .hraci_2.prev
mv ".hraci_3" .hraci_3.prev
touch .hraci_1 .hraci_2 .hraci_3

while IFS= read -r LINE; do
    if [[ "$LINE" == "**"* ]]; then
        ((count++))
        output_file=".hraci_$count"
        touch $output_file
    else
        echo "$LINE" >> "$output_file"
    fi
done < .hraci_current

touch .promoted_today
while IFS= read -r LINE; do
    if ! grep -q "$LINE" ".hraci_1.prev"; then
        echo "$LINE" >> .promoted_today
    fi
done < .hraci_1

touch .died_today
while IFS= read -r LINE; do
    if ! grep -q "$LINE" ".hraci_3.prev"; then
        echo "$LINE" >> .died_today
    fi
done < .hraci_3

touch .revived_today
while IFS= read -r LINE; do
    if ! grep -q "$LINE" ".hraci_2.prev"; then
        echo "$LINE" >> .revived_today
    fi
done < .hraci_2

curl -sS -X POST -H "Content-Type: application/json" -d \
    "{\"content\": \"**Žebříček hráčů $(date +%F | tr -d "\n")**\\n$(cat .hraci_1 | sed 's/$/\\n/' | tr -d "\n")\",
      \"embeds\": [{
      \"title\": \"Včera povýšeni\",
          \"description\": \"$(cat .promoted_today | sed 's/$/\\n/' | tr -d "\n")\",
          \"color\": 15844367
      },
      { \"title\": \"Včera zemřeli\",
          \"description\": \"$(cat .died_today | sed 's/$/\\n/' | tr -d "\n")\",
          \"color\": 15548997
      },
      { \"title\": \"Včera oživeni\",
          \"description\": \"$(cat .revived_today | sed 's/$/\\n/' | tr -d "\n")\",
          \"color\": 1752220
      }
      ],
      \"attachments\": [] }" $WEBHOOKURL

rm .died_today .promoted_today .revived_today

