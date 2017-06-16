#!/bin/bash

VOLUME=$(pactl list sinks | grep -A15 -P "(\#|№)$SINK" | grep -P "\d+\s*\/\s*\d+\%" | head -1 | awk "{print \$5}")
if [[ "${1:0:1}" = "+" || "${1:0:1}" = "-" ]]
then
    pactl set-sink-volume @DEFAULT_SINK@ $1
else
    pactl set-sink-mute @DEFAULT_SINK@ toggle
fi

VOLUME=$(pactl list sinks | grep -A15 -P "(\#|№)$SINK" | grep -P "\d+\s*\/\s*\d+\%" | head -1 | awk "{print \$5}")
VOLUME=${VOLUME:0:-1}
MUTED=$(pactl list sinks | grep -A15 -P "(\#|№)$SINK" | grep Mute | awk "{print \$2}")

if [[ $MUTED == "yes" ]]
then
    ICON="muted"
elif [[ "$VOLUME" == "0" ]]
then
    ICON="off"
elif [[ "$VOLUME" -lt "33" ]]
then
    ICON="low"
elif [[ "$VOLUME" -lt "66" ]]
then
    ICON="medium"
else
    ICON="high"
fi

NOTIFY_ARGS=(--session
             --dest org.freedesktop.Notifications
	     --object-path /org/freedesktop/Notifications)

HINTS="{\"value\": <int32 $VOLUME>}"
REPLACE_ID=0
if [ -f $HOME/.config/i3/.volume-notification-lock ]
then
    REPLACE_ID=$(< $HOME/.config/i3/.volume-notification-lock)
fi
ID=$(gdbus call "${NOTIFY_ARGS[@]}"  --method org.freedesktop.Notifications.Notify "volume-control" "$REPLACE_ID" "/usr/share/notify-osd/icons/hicolor/scalable/status/notification-audio-volume-$ICON.svg" "$VOLUME %" "" [] "$HINTS" "int32 2000" | sed 's/(uint32 \(.*\),)/\1/')

echo $ID > $HOME/.config/i3/.volume-notification-lock
sleep 2 && [ "$(echo "$(date +'%s') - $(stat $HOME/.config/i3/.volume-notification-lock -c "%Z")" | bc)" -gt "1" ] && rm $HOME/.config/i3/.volume-notification-lock &
