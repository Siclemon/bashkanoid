#!/bin/bash

move_paddle() {
    local direction=$1
    if is_movement_legal "$direction"; then
        do_paddle_movement "$direction"
        draw_paddle
    fi
}

is_movement_legal() {
    local direction=$1
    case "$direction" in
        "left") (( paddle_left > paddle_min_column )) ;;
        "right") (( paddle_left < paddle_max_column )) ;;
    esac
}

do_paddle_movement() {
    local direction=$1
    case "$direction" in
        "left") 
            local new_pos=$((paddle_left-paddle_speed))
            paddle_left=$((new_pos>paddle_min_column-1 ? new_pos : paddle_min_column))
            ;;
        "right")
            local new_pos=$((paddle_left+paddle_speed))
            paddle_left=$((new_pos<paddle_max_column ? new_pos : paddle_max_column))
            ;;
    esac
}