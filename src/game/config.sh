#!/bin/bash

get_config() {
	if [ ! -f config.txt ]; then
		create_config
	fi
	readarray -t lines < config.txt

	for line in "${lines[@]}"; do
		config[${line%%=*}]=${line#*=}
	done
}

create_config() {
	local config_array=(
		"skin=default"
		"brick_skin"
		"fps=60"
		"player_speed=2"
		"base_speed=0.7"
		"base_angle=310"
		"base_y=5"
		"base_x=40"
		"debug=false"
		"cheat=false"
	)
	printf "%s\n" "${config_array[@]}" > config.txt
}

init_from_config() {
	player_speed=${config[player_speed]}
	ball_angle=${config[base_angle]}
	ball_speed=${config[base_speed]}
	ball_y=${config[base_y]}
	ball_x=${config[base_x]}
	frame_refresh_delay=$(( 1000/config[fps] ))
	skin=${config[ball_skin]}
	brick_skin=${config[brick_skin]}
}