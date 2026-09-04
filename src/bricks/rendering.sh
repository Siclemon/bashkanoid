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
	for (( j=0; j<BRICK_HEIGHT; j++ )) ; do
		reset_line $((line+j))
	done
	for b in "${!row[@]}"; do
		if is_alive "$line" "$b"; then
			local column=$(get_column "$line" "$b")
			local -n current_brick_skin="brick_$(get_health "$line" "$b")"
			for (( j=0; j<BRICK_HEIGHT; j++ )) ; do
				draw "${current_brick_skin[$j]}" "$((line+j))" "$column"
			done
		fi
	done
}