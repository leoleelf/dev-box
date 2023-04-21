#!/bin/bash

# Utility function to print a message to the console
function log {
    MESSAGE="$1"
    echo "$MESSAGE"
}

# Utility function to check if a command exists
function command_exists {
    command -v "$1" >/dev/null 2>&1
}

# Utility function to check if a directory exists
function directory_exists {
    [ -d "$1" ]
}
