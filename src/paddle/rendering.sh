#!/bin/bash

draw_paddle() {
	reset_line "$paddle_row"
	draw "████████████" "$paddle_row" "$paddle_left"
}