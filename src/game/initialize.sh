#!/bin/bash
readonly PI=3.1416
readonly BALL_HEIGHT=2
readonly BALL_WIDTH=4
readonly PADDLE_WIDTH=12
readonly GAME_REFRESH_RATE=10
readonly BRICK_HEIGHT=3
readonly BRICK_WIDTH=12

initialize() {
	initialize_variables
	initialize_game
}

initialize_variables() {
	screen_width=$(tput cols)
	screen_height=$(tput lines)
	paddle_row=$((screen_height - 2))
	paddle_left=$(( (screen_width - PADDLE_WIDTH) / 2))
	paddle_min_column=1
	paddle_max_column=$((screen_width-PADDLE_WIDTH))

	loops=0

	get_config
	initialize_from_config

	mapfile -t ball < skins/ball/"$skin".txt
	mapfile -t brick_1 < skins/brick/"$brick_skin"/1.txt
	mapfile -t brick_2 < skins/brick/"$brick_skin"/2.txt
	mapfile -t brick_3 < skins/brick/"$brick_skin"/3.txt
	reset_frame
}

initialize_game() {
	calc_velocities
	calc_ball_position
	draw_ball_in_frame
	draw_paddle
	spawn_bricks
	draw_frame
}