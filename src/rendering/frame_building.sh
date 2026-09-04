#!/bin/bash
declare -ga "frame"
declare -ga "changed_rows"

reset_line() {
	local line="$1"
	printf -v "frame[$line]" "%*s" "$screen_width" ""
}

reset_frame() {
	for ((y=1; y<=screen_height; y++)); do
		reset_line "$y"
	done
}

draw() {
	:
	# local new_element="$1"
	# local new_element_row="$2"
	# local new_element_col="$3"

	# local string_to_change=${frame[$new_element_row]}
	# local new_string=${string_to_change:0:$((new_element_col-1))}$new_element${string_to_change:$((new_element_col-1+${#new_element}))}
	# frame[new_element_row]="$new_string"

	# changed_rows[new_element_row]=true
}