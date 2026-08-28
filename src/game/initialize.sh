#!/bin/bash

init_variables() {
	cols=$(tput cols)
	rows=$(tput lines)
	player_position_y=$((rows - 2))
	player_position_x=$(( (cols - PLAYER_WIDTH) / 2))
	player_min_x=1
	player_max_x=$((cols-PLAYER_WIDTH))

	loops=0

	get_config
	init_from_config

	mapfile -t ball < skins/ball/"$skin".txt
	mapfile -t brick_1 < skins/brick/"$brick_skin"/1.txt
	mapfile -t brick_2 < skins/brick/"$brick_skin"/2.txt
	mapfile -t brick_3 < skins/brick/"$brick_skin"/3.txt
	reset_frame
}