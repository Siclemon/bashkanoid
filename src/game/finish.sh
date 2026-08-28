#!/bin/bash

stop() {
	printf "\033[%s;1H" "$((screen_height+1))"
	compute_times
	printf "\033[?25h"
	exit
}

game_over() {
	printf "\033c"
	printf "\033[?25h"
	compute_times
	echo "t nul"
}