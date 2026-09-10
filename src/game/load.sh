#!/bin/bash

load_code() {
    local files=( ./src/**/*.sh )

    for file in "${files[@]}"; do
        source $file
    done
}