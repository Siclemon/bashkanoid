#!/bin/bash

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