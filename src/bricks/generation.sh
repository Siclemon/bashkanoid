#!/bin/bash

spawn_bricks() {
	create_bricks_rows
	gen_bricks
	draw_all_bricks_in_frame
}

create_bricks_rows() {
	brick_rows=$(( screen_height * 2 / 5 ))

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
	local bricks_slots=$((screen_width / 12))
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