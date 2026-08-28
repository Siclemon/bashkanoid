#!/bin/bash
readonly PI=3.1416
readonly BALL_HEIGHT=2
readonly BALL_WIDTH=4
readonly PLAYER_WIDTH=12
readonly GAME_REFRESH_RATE=10
readonly BRICK_HEIGHT=3
readonly BRICK_WIDTH=12

declare -a "frame"
declare -a "changed_rows"
declare -a "timers"
declare -A "config"

init_terminal() {
	printf "\033c"
	printf "\033[?25l"
	stty -echo
}

init_game() {
	calc_velocities
	calc_ball_position
	draw_ball_in_frame
	draw_player_in_frame
	draw_frame
}

spawn_bricks() {
	create_bricks_rows
	gen_bricks
	draw_all_bricks_in_frame
}

create_bricks_rows() {
	brick_rows=$(( rows * 2 / 5 ))

	for (( i=1; i<=brick_rows; i+=BRICK_HEIGHT)); do
		declare -a brick_row_${i}
	done
}

gen_bricks() {
	gen_bricks_in_row 1 10
	gen_bricks_in_row 4 4
	gen_bricks_in_row 7 6
	gen_bricks_in_row 10 7
	gen_bricks_in_row 13 8
	gen_bricks_in_row 16 10
}

gen_bricks_in_row() {
	local -n row="brick_row_${1}"
	local amount=$2
	local -a bricks
	local bricks_slots=$((cols / 12))
	bricks=( $(shuf -i 0-$((bricks_slots-1)) -n $((bricks_slots*amount/10))) )
	for br in "${bricks[@]}"; do
		local rng=$RANDOM
		local health=$(( 1 + (( (1 + rng % 100) < 90)) + (( (1 + rng % 100) < 40 )) ))
		local type=0
		printf -v column "%03d" "$((1+br*12))"
		local new_brick=$health$type$column
		unset column
		row+=( "$new_brick" )
		echo "$new_brick" >> logs/br.txt
	done
	echo >> logs/br.txt
}

draw_all_bricks_in_frame() {
	for (( i=1; i<=brick_rows; i+=BRICK_HEIGHT)); do
		draw_brick_row_in_frame "$i"
	done
}

draw_brick_row_in_frame() {
	local line=$1
	local -n row="brick_row_${1}"
	for (( j=0; j<BRICK_HEIGHT; j++ )) ; do
		reset_line $((line+j))
	done
	for b in "${row[@]}"; do
		local health=$((b/10000))
		if ((health>0)); then
			local column=$((b%1000))
			local -n current_brick_skin="brick_${health}"
			for (( j=0; j<BRICK_HEIGHT; j++ )) ; do
				draw "${current_brick_skin[$j]}" "$((line+j))" "$column"
			done
		fi
	done
}

check_collisions_bricks() {
	check_bricks_top_bottom_rows
	check_bricks_current_rows
}

check_bricks_top_bottom_rows() {
	if (( ball_row % BRICK_HEIGHT == 1 && ball_angle > 0 && ball_angle < 180)); then
		local top_row=$((ball_row - BRICK_HEIGHT))
		check_bricks_y_collision $top_row
	elif (( (ball_row + BALL_HEIGHT) % BRICK_HEIGHT == 1 && ball_angle > 180 && ball_angle < 360)); then
		local bottom_row=$((ball_row + BALL_HEIGHT))
		check_bricks_y_collision $bottom_row
	fi
}

check_bricks_current_rows() {
	local first_brick_row_to_check
	local x_collision
	local rows_to_check
	rows_to_check=$(( 1 + (BALL_HEIGHT-2) / BRICK_HEIGHT + $(( (BALL_HEIGHT-2) % BRICK_HEIGHT + (ball_row-1) % BRICK_HEIGHT >= BRICK_HEIGHT )) ))
	first_brick_row_to_check=$((ball_row - (ball_row - 1) % BRICK_HEIGHT))

	for ((i=0; i<rows_to_check; i++)); do
		local current_row=$((first_brick_row_to_check + i * BRICK_HEIGHT))
		if check_bricks_from_row "inside" "$current_row" ; then
			bounce_y
			draw_brick_row_in_frame $current_row
		elif check_bricks_from_row "x" "$current_row" ; then
			x_collision=true
			draw_brick_row_in_frame $current_row
		fi
	done
	if [[ $x_collision = true ]]; then
		bounce_x
	fi
}

check_bricks_y_collision() {
	local row_to_check=$1
	if check_bricks_from_row "y" "$row_to_check" ; then
		bounce_y
		draw_brick_row_in_frame "$row_to_check"
	fi
}

check_bricks_from_row() {
	local mode="$1"
	local line="$2"
	local collision
	local -n row="brick_row_$line"
	collision=false
	for brick_index in "${!row[@]}"; do
		local current_brick=${row[brick_index]}
		local health=$((current_brick/10000))
		if (( health > 0 )); then
			local column=$((current_brick%1000))
			if brick_collision_check "$mode" "$column"; then
				collision=true
				row[brick_index]=$((current_brick-10000))
			fi
		fi
	done

	$collision
}

brick_collision_check() {
	local brick_left=$2
	local brick_right=$((brick_left+BRICK_WIDTH))
	local ball_left=$ball_column
	local ball_right=$((ball_left+BALL_WIDTH))
	case $1 in
		x) (( ball_right >= brick_left && ball_left <= brick_right )) ;;
		y) (( ball_right > brick_left && ball_left < brick_right )) ;;
		inside) (( ball_left >= brick_left - BALL_WIDTH/2 && ball_right <= brick_right + BALL_WIDTH/2 )) ;;
	esac
}

handle_input() {
	case "$1" in
		"q")
			if (( player_position_x > player_min_x )); then
				local new_pos=$((player_position_x-player_speed))
				player_position_x=$((new_pos>player_min_x-1 ? new_pos : player_min_x))
				draw_player_in_frame
			fi
			;;
		"d")
			if (( player_position_x < cols-PLAYER_WIDTH )); then
				local new_pos=$((player_position_x+player_speed))
				player_position_x=$((new_pos<player_max_x ? new_pos : player_max_x))
				draw_player_in_frame
			fi
			;;
	esac
}

calc_velocities() {
	ball_velocity_x=$(echo "scale=3; c($ball_angle*$PI/180)" | bc -l )
	ball_velocity_y=$(echo "scale=3; -s($ball_angle*$PI/180)" | bc -l )
}

move_ball() {
	ball_x=$(echo "scale=3; $ball_x + $ball_velocity_x * $ball_speed" | bc -l)
	ball_y=$(echo "scale=3; $ball_y + $ball_velocity_y * $ball_speed" | bc -l)
}

calc_ball_position() {
	old_ball_row="$ball_row"
	old_ball_column="$ball_column"
	ball_row=$(echo " scale=0; (($ball_y*0.5)+0.5)/1" | bc -l)
	ball_column=$(echo " scale=0; (($ball_x)+0.5)/1" | bc -l)
}

check_collisions() {
	if (( ball_row == player_position_y-BALL_HEIGHT && (ball_column>player_position_x-BALL_WIDTH && ball_column<player_position_x+PLAYER_WIDTH) )); then
		bounce_player
	elif (( ball_row >= player_position_y-BALL_HEIGHT )) && [[ ${config[cheat]} = true ]] || (( ball_row <= 1 )) ; then
		bounce_y
	fi
	if (( ball_column >= cols-BALL_WIDTH-1 || ball_column <= 2 )); then
		bounce_x
	fi
	if (( ball_row <= brick_rows + BRICK_HEIGHT + 1 )); then
		check_collisions_bricks
	fi
}

bounce_x() {
	ball_angle=$(( (540-ball_angle) % 360 ))
	calc_velocities
}

bounce_y() {
	ball_angle=$(( 360-ball_angle ))
	calc_velocities
}

bounce_player() {
	local offset=$(( (ball_column + BALL_WIDTH / 2) - (player_position_x + PLAYER_WIDTH / 2) ))
	ball_angle=$(( 90 - offset * 7 ))
	calc_velocities
}

draw_player_in_frame() {
	reset_line "$player_position_y"
	draw "████████████" "$player_position_y" "$player_position_x"
}

draw_ball_in_frame() {
	for (( i=0; i<BALL_HEIGHT; i++ )) ; do
		draw "${ball[$i]}" "$((ball_row+i))" "$ball_column"
	done
}

erase_ball_in_frame() {
	for (( i=0; i<BALL_HEIGHT; i++ )) ; do
		draw "    " "$((old_ball_row+i))" "$old_ball_column"
	done
}

game_over() {
	printf "\033c"
	printf "\033[?25h"
	compute_times
	echo "t nul"
}

print_debug() {
	printf "\033[1;1H%d  " $loops
	printf "\033[2;1Hvx:%s  " "$ball_velocity_x"
	printf "\033[3;1Hvy:%s  " "$ball_velocity_y"
	printf "\033[4;1Hangle:%s  " "$ball_angle"
	printf "\033[5;1Hrow:%s col:%s  " "$ball_row" "$ball_column"
	printf "\033[6;1Hloop duration:%s  " "$1"
}

compute_times() {
	local average_time
	local sum=0
	for time in "${timers[@]}" ; do
		((sum+=time))
	done
	average_time=$(echo "scale=3; $sum/$loops" | bc -l)
	echo -e "average loop time: ${average_time}ms"
	echo "$(date +'%d/%m/%Y %R') - $average_time" >> logs/average_times.txt
	printf "%s\n" "${timers[@]}" > logs/timer.txt
}

stop() {
	printf "\033[%s;1H" "$((rows+1))"
	compute_times
	printf "\033[?25h"
	exit
}

main() {
	trap stop SIGINT

	init_terminal
	init_variables
	init_game

	spawn_bricks

	local lost=0
	local last_game_update
	local last_display

	last_game_update=$(date +%s%3N)
	last_display=$(date +%s%3N)

	while (( lost == 0)) ; do
		local now
		local start_time
		local end_time
		local duration
		local input
		local active_input

		((loops++))
		now=$(date +%s%3N)
		start_time="$now"

		read -t0.001 -n1 -s -r input
		[ -n "${input}" ] && active_input="$input"

		if (( now-last_game_update >= GAME_REFRESH_RATE)); then

			handle_input "$active_input"
			
			move_ball
			calc_ball_position
			check_collisions

			if (( ball_row>=player_position_y-BALL_HEIGHT+1 )); then
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

		#printf "%s\n" "${!changed_rows[@]}" > uqss2.txt # DEBUG: rows' indices to rewrite
		#printf "%s\n" "${frame[@]}" > uqss.txt # DEBUG: the whole frame

		end_time=$(date +%s%3N)
		duration=$((end_time - start_time))
		timers+=("$duration")

		if [[ ${config[debug]} = true ]]; then
			print_debug $duration
		fi
	done

	game_over
}

main "$@"