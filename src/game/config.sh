#!/bin/bash
declare -gA "config"

initialize_from_config() {
    get_config
    
    paddle_speed=${config[paddle_speed]}
    ball_angle=${config[base_angle]}
    ball_speed=${config[base_speed]}
    ball_y=${config[base_y]}
    ball_x=${config[base_x]}
    frame_refresh_delay=$((1000/config[fps]))
    ball_skin=${config[ball_skin]}
    brick_skin=${config[brick_skin]}
    paddle_skin=${config[paddle_skin]}
}

get_config() {
    local key
    local value
    
    if [[ ! -f config.txt ]]; then
        create_config
    fi
    
    while IFS="=" read -r key value; do
        [[ -n "$key" && "$key" != \#* ]] && config["$key"]="$value"
    done < config.txt

    # while IFS= read -r line; do
    #     [[ -z $line || "$line" != *"="* ]] && continue
    #     local key=${line%%=*}
    #     local value=${line#*=}
    #     config["$key"]="$value"
    #     echo "$key: ${config[$key]}"
    # done < config.txt
}

create_config() {
    local config_array=(
        "# GAME"
        "fps=100"
        "debug=false"
        "godmode=true"
        ""
        "# BALL"
        "ball_skin=small"
        "base_speed=0.7"
        "base_angle=310"
        "base_y=5"
        "base_x=40"
        ""
        "# BRICKS"
        "brick_skin=default"
        ""
        "# PADDLE"
        "paddle_skin=default"
        "paddle_speed=2"
    )
    printf "%s\n" "${config_array[@]}" > config.txt
}

is_godmode() {
    [[ ${config[cheat]} = true ]]
}