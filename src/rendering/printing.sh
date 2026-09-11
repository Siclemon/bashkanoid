#!/bin/bash

draw_frame() {
	local i
	for (( i=0 ; i<game_area_height ; i++)) ; do
		if [[ ${changed_rows[i]} = "true" ]] ; then
			printf "\033[%s;%sH%s" "$((i+game_area_first_row))" "$game_area_first_col" "${frame[$i]}"
			unset "changed_rows[i]"
		fi
	done
}

draw_border_around() {
    local min_y max_y min_x max_x
    min_y=$(($1 - 1))
    max_y=$(($2 + 1))
    min_x=$(($3 - 2))
    max_x=$(($4 + 2))
    local y x
    for (( y=min_y; y<=max_y; y++ )); do
        for (( x=min_x; x<=max_x; x++)); do
            (( y == min_y || y == max_y || x <= min_x + 1 || x >= max_x - 1 )) && printf "\033[%s;%sH%s" "$y" "$x" "█"
        done
    done
}

clear_terminal() {
	printf "\033c"
}

hide_cursor() {
	printf "\033[?25l"
}

show_cursor() {
	printf "\033[?25h"
}

hide_input() {
	stty -echo
}

show_input() {
	stty echo
}