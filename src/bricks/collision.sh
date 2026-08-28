#!/bin/bash

handle_bricks_collision() {
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