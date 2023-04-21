#!/bin/bash

# Import the dev-box package
source "$( dirname "${BASH_SOURCE[0]}" )/dev-box/utils.sh"
source "$( dirname "${BASH_SOURCE[0]}" )/dev-box/commands/init.sh"
source "$( dirname "${BASH_SOURCE[0]}" )/dev-box/commands/run.sh"

# Define the version number
VERSION="1.0.0"

# Define the main function
function main {
    # Parse the command-line arguments
    COMMAND="$1"
    shift
    ARGS="$@"

    # Call the appropriate command function
    case "$COMMAND" in
        init)
            init $ARGS
            ;;
        run)
            run $ARGS
            ;;
        *)
            echo "Usage: dev-box [init|run]"
            exit 1
            ;;
    esac
}

# Call the main function with the command-line arguments
main "$@"
