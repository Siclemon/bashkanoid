#!/bin/bash
declare -a "timers"

compute_times() {
	local average_time
	local sum=0
	local time
	for time in "${timers[@]}" ; do
		((sum+=time))
	done
	average_time=$(echo "scale=3; $sum/$loops" | bc -l)
	echo -e "average loop time: ${average_time}ms"
	echo "$(date +'%d/%m/%Y %R') - $average_time" >> logs/average_times.txt
	printf "%s\n" "${timers[@]}" > logs/timer.txt
}

print_debug() {
	printf "\033[1;1H%d  " "$loops"
	printf "\033[2;1Hvx:%s  " "$ball_velocity_x"
	printf "\033[3;1Hvy:%s  " "$ball_velocity_y"
	printf "\033[4;1Hangle:%s  " "$ball_angle"
	printf "\033[5;1Hrow:%s col:%s  " "$ball_row" "$ball_column"
	printf "\033[6;1Hloop duration:%s  " "$1"
}