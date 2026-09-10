#!/bin/bash

initialize() {
	initialize_variables
	initialize_from_config
	initialize_game_area
	initialize_skins
	initialize_game_state
	initialize_frame
	initialize_terminal
	draw_frame
	draw_game_area_frame
}

initialize_variables() {
	screen_width=$(tput cols)
	screen_height=$(tput lines)
	paddle_row=$((screen_height - 2))
	paddle_left=$(( (screen_width - PADDLE_WIDTH) / 2))
	paddle_min_column=1
	paddle_max_column=$((screen_width-PADDLE_WIDTH))

	loops=0
}

initialize_skins() {
	mapfile -t ball < skins/ball/"$ball_skin".txt
	mapfile -t brick_1 < skins/brick/"$brick_skin"/1.txt
	mapfile -t brick_2 < skins/brick/"$brick_skin"/2.txt
	mapfile -t brick_3 < skins/brick/"$brick_skin"/3.txt
	mapfile -t paddle < skins/paddle/"$paddle_skin".txt
}

initialize_game_state() {
	calc_velocities
	calc_ball_position
	spawn_bricks
}

initialize_frame() {
	reset_frame
	draw_paddle
	draw_ball_in_frame
	draw_all_bricks_in_frame
}

initialize_terminal() {
	clear_terminal
	hide_cursor
	hide_input
}