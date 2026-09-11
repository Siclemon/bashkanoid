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
    draw_game_area_border
}

initialize_variables() {
    screen_width=$(tput cols)
    screen_height=$(tput lines)
    
    loops=0
}

initialize_game_area() {
    game_area_width=
    calc_game_area_width
    game_area_height=$(( screen_height - 4 ))
    game_area_first_col=$(( (screen_width - game_area_width) / 2 ))
    game_area_first_row=1
    game_area_last_col=$(( game_area_first_col + game_area_width ))
    game_area_last_row=$(( game_area_first_row + game_area_height ))
}

calc_game_area_width() {
    game_area_width=$(max $((screen_width*7/10)) 48)
    game_area_width=$(( (game_area_width / BRICK_WIDTH) * BRICK_WIDTH ))
}

initialize_skins() {
    mapfile -t ball < skins/ball/"$ball_skin".txt
    mapfile -t brick_1 < skins/brick/"$brick_skin"/1.txt
    mapfile -t brick_2 < skins/brick/"$brick_skin"/2.txt
    mapfile -t brick_3 < skins/brick/"$brick_skin"/3.txt
    mapfile -t paddle < skins/paddle/"$paddle_skin".txt
}

initialize_game_state() {
    initialize_paddle
    calc_velocities
    calc_ball_position
    spawn_bricks
}

initialize_paddle() {
    paddle_row=$((game_area_last_row - 3))
    paddle_min_column=$((2))
    paddle_max_column=$((game_area_width-PADDLE_WIDTH+1))
    paddle_left=$(( (game_area_width - PADDLE_WIDTH) / 2))
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