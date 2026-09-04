#!/bin/bash
trap 'printf "DEBUG: %s:%s: %s\n" "${BASH_SOURCE[0]}" "$LINENO" "$BASH_COMMAND" >&2' DEBUG
source ./src/game/load.sh

load_code
initialize
game