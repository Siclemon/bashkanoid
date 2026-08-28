#!/bin/bash

draw_frame() {
	for (( i=1 ; i<screen_height ; i++)) ; do
		if [[ ${changed_rows[i]} = "true" ]] ; then
			printf "\033[%s;1H%s" "$i" "${frame[$i]}"
			unset "changed_rows[i]"
		fi
	done
}

init_terminal() {
	printf "\033c"
	printf "\033[?25l"
	stty -echo
}