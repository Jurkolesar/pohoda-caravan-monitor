#!/bin/bash
# Checks the Pohoda ticket shop for a caravan parking ticket.
# Prints "FOUND|<url>|<snippet>" when found, otherwise "NOT_FOUND".
PATTERN='karavan|caravan|obytn|camper|campervan'
URLS=(
  "https://shop.pohodafestival.sk/sk/listky-2027"
  "https://shop.pohodafestival.sk/en/listky-2027"
  "https://www.pohodafestival.sk/sk/shop"
)
ok=0
for url in "${URLS[@]}"; do
  page=$(curl -sL --max-time 30 -A "Mozilla/5.0 (Macintosh)" "$url") || continue
  [ -n "$page" ] && ok=1
  hit=$(printf '%s' "$page" | LC_ALL=C grep -ioE ".{0,60}($PATTERN).{0,60}" | head -1 | sed 's/<[^>]*>//g')
  if [ -n "$hit" ]; then echo "FOUND|$url|$hit"; exit 0; fi
done
[ $ok = 1 ] && echo "NOT_FOUND" || { echo "FETCH_FAILED"; exit 1; }
