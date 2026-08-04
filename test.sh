#!/bin/bash

readarray -t config < config.txt
declare -A configs

for line in "${config[@]}"; do
    key="${line%%*=}"
    value="${line#*=}"
    #configs[$key]="$value"
    configs[${line%%=*}]=${line#*=}
done

echo "${configs[fps]}"

echo "${!configs[@]}"
echo "${config[@]}"