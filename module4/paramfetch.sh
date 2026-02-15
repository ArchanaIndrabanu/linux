#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ]; then
    exit 1
fi

ip="$1"
op="$2"

> "$op"

while IFS= read -r line
do
    if echo "$line" | grep -q '"frame.time"'; then
        echo "$line" >> "$op"
    fi

    if echo "$line" | grep -q '"wlan.fc.type"'; then
        echo "$line" >> "$op"
    fi

    if echo "$line" | grep -q '"wlan.fc.subtype"'; then
        echo "$line" >> "$op"
    fi

done < "$ip"

echo "Parameters Extracted"
