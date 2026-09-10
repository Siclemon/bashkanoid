#!/bin/bash

draw_all_bricks_in_frame() {
	local brick_row
	for (( brick_row=1; brick_row<=brick_rows; brick_row+=BRICK_HEIGHT)); do
		draw_brick_row_in_frame "$brick_row"
	done
}

draw_brick_row_in_frame() {
	local line=$1
	local -n row="brick_row_${1}"
	local j
	for (( j=0; j<BRICK_HEIGHT; j++ )) ; do
		reset_line $((line+j))
	done
	local b
	for b in "${!row[@]}"; do
		local brick_health brick_column
		get_brick_data "$line" "$b"
		if ((brick_health)); then
			local -n current_brick_skin="brick_${brick_health}"
			local j
			for (( j=0; j<BRICK_HEIGHT; j++ )) ; do
				draw "${current_brick_skin[$j]}" "$((line+j))" "$brick_column"
			done
		fi
	done
}