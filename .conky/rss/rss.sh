#!/bin/bash
LINES=5
curl -s https://www.hackerrank.com/calendar/feed.rss | grep -E "title|startTime" | sed 's/<startTime>//g' | sed 's/<title>//g' | sed 's/<\/startTime>//g' | sed ':a;N;$!ba;s/<\/title>\n//g' | tail -n $(($LINES+1))| head -n $(($LINES)) | sed 's/ \+/ /g'
