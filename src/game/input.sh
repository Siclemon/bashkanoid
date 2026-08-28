#!/bin/bash

handle_input() {
	case "$1" in
		"q") move_paddle left ;;
		"d") move_paddle right ;;
	esac
}