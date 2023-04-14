#!/bin/bash

function usage {
    echo "Usage: $0 [-h]"
    echo ""
    echo "Options:"
    echo "  -h    Display this help message."
    exit 1
}

if [ $# -eq 0 ]; then
    usage
    exit 1
fi
