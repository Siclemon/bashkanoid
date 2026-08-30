#!/bin/bash

now_ms() {
    local t=$(date +%s%N)
    t=${t:7:6}
    t=$((10#$t))
    echo $t
}

game() {
    trap stop SIGINT
    
    local lost=0
    local last_game_update
    local last_display
    
    last_game_update=$(now_ms)
    last_display=$(now_ms)
    
    while (( lost == 0)) ; do
        local now
        local start_time
        local end_time
        local duration
        local input
        local active_input
        
        ((loops++))
        now=$(now_ms)
        start_time="$now"
        
        read -t0.001 -n1 -s -r input
        [ -n "${input}" ] && active_input="$input"
        
        if (( now-last_game_update >= GAME_REFRESH_RATE)); then
            
            handle_input "$active_input"
            
            move_ball
            calc_ball_position
            check_collisions
            
            if (( ball_row>=paddle_row-BALL_HEIGHT+1 )); then
                lost=1
            fi
            
            erase_ball_in_frame
            draw_ball_in_frame
            active_input=
            last_game_update="$now"
        fi
        
        if (( now-last_display >= frame_refresh_delay || lost == 1)); then
            draw_frame
            last_display="$now"
        fi
        
        end_time=$(now_ms)
        duration=$((end_time - start_time))
        timers+=("$duration")
        
        if [[ ${config[debug]} = true ]]; then
            print_debug $duration
        fi
    done
    
    game_over
}