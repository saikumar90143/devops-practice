#!/bin/bash
CURRENT_DIR=$(pwd)

echo "Searching for log files older than 7 days in $CURRENT_DIR"

find $CURRENT_DIR -name "*.log" -type f -mtime +7

while IFS= read -r file

do
    echo "Deleting old log file: $file"
    rm -rf "$file"
done <<< "$(find $CURRENT_DIR -name "*.log" -type f -mtime +7)"

