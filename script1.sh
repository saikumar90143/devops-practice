#!/bin/bash

GREETINGS="Hello, World!"

SCRIPT_NAME=$(echo "$0" | cut -d '.' -f2)
echo $GREETINGS

echo "$SCRIPT_NAME"