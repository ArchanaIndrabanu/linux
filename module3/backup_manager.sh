#!/bin/bash

src="$1"
dest="$2"
ext="$3"

if [ -z "$src" ] || [ -z "$dest" ] || [ -z "$ext" ]; then
    exit 1
fi

if [ ! -d "$src" ]; then
    exit 1
fi

if [ ! -d "$dest" ]; then
    mkdir -p "$dest" 
fi

files=("$src"/*"$ext")

if [ ${#files[@]} -eq 0 ]; then
    echo "No matching files found"
    exit 1
fi

export count=0
t_size=0

for f in "${files[@]}"
do
    if [ -f "$f" ]; then
        size=$(stat -c %s "$f")
        echo "$(basename "$f") - $size bytes"
    fi
done

for f in "${files[@]}"
do
    if [ -f "$f" ]; then
        de="$dest/$(basename "$f")"

        if [ ! -f "$de" ] || [ "$f" -nt "$de" ]; then
            cp "$f" "$de"
            ((count++))
            size=$(stat -c %s "$f")
            ((t_size+=size))
        fi
    fi
done

report="$dest/report.log"

{
    echo "Report:"
    echo "Backup Directory: $dest"
    echo "Total Files: $count"
    echo "Total Size: $t_size bytes"
} > "$report"

echo "Backup Complete, Report Generated"
