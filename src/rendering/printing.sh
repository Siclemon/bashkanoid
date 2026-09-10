#!/bin/bash

draw_frame() {
	local i
	for (( i=1 ; i<screen_height ; i++)) ; do
		if [[ ${changed_rows[i]} = "true" ]] ; then
			printf "\033[%s;1H%s" "$i" "${frame[$i]}"
			unset "changed_rows[i]"
		fi
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