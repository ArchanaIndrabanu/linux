#!/bin/bash

search_dir() {

    dir="$1"
    key="$2"

    for i in "$dir"/*; do
        if [[ -f "$i" ]]; then
            if grep -q "$key" "$i"; then
                echo "Keyword Found in: $i"
            fi
        elif [[ -d "$i" ]]; then
            search_dir "$i" "$key"
        fi
    done
}

log_error() {
    echo "The Error: $1"
    echo "The Error: $1" >> error.log
}

help() {
    cat << EOF
====================================
File Analyzer Script
====================================

Usage:
  $0 -d <directory> -k <keyword>
  $0 -f <file> -k <keyword>
  $0 --help

Options:
  -d <directory>   Directory to search recursively
  -k <keyword>     Keyword to search
  -f <file>        File to search
  --help           Display help menu
====================================
EOF

    echo "Name of the Script: $0"
    echo "No. of Arguments: $#"
    echo "Arguments: $@"
}

validate() {

    if [[ -z "$1" ]]; then
        log_error "Keyword is Empty"
        exit 1
    fi

    if [[ ! "$1" =~ ^[a-zA-Z0-9_]+$ ]]; then
        log_error "Invalid Keyword"
        exit 1
    fi
}

if [[ "$1" == "--help" ]]; then
    help
    exit 0
fi

while getopts ":d:f:k:" opt; do
    case "$opt" in
        d) dir="$OPTARG" ;;
        f) file="$OPTARG" ;;
        k) key="$OPTARG" ;;
        \?) log_error "Invalid Argument"; exit 1 ;;
        :) log_error "Argument Not Given"; exit 1 ;;
    esac
done

validate "$key"

if [[ -n "$dir" ]]; then

    if [[ ! -d "$dir" ]]; then
        log_error "Directory Not Exist"
        exit 1
    fi

    search_dir "$dir" "$key"

elif [[ -n "$file" ]]; then

    if [[ ! -f "$file" ]]; then
        log_error "File Not Exist"
        exit 1
    fi

    while read -r line; do
        if grep -q "$key" <<< "$line"; then
            echo "Keyword Found: $line"
        fi
    done < "$file"

else
    echo "File or Directory is not given"
    exit 1
fi
