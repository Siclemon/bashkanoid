#!/bin/bash

stop() {
	printf "\033[%s;1H" "$((screen_height+1))"
	compute_times
	restore_terminal
	is_debug && set | grep '^[a-z].*='
	initialize_game_area
	exit
}

game_over() {
	compute_times
	clear_terminal
	restore_terminal
	is_debug && set | grep '^[a-z].*='
	echo "t nul"
}

restore_terminal() {
	show_cursor
	show_input
}