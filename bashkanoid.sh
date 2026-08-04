#!/bin/bash
pi=3.1416

cols=$(tput cols)
rows=$(tput lines)

declare -a "frame"
declare -a "changed_rows"
declare -a "timers"
declare -A "config"

get_config() {
	readarray -t lines < config.txt

	for line in "${lines[@]}"; do
		config[${line%%=*}]=${line#*=}
	done
}

init_from_config() {
	ball_angle=${config[base_angle]}
	ball_speed=${config[base_speed]}
	frame_refresh_delay=$(( 1000/config[fps] ))
}

reset_line() {
	local line="$1"
	printf -v "frame[$line]" "%*s" "$cols" ""
}

for ((y=1; y<=rows; y++))
do
	reset_line "$y"
done

player_position_y=$((rows - 2))
player_position_x=$((cols / 2))

frames=0

mapfile -t ball < skins/ball/default.txt
ball_y=5
ball_x=40
ball_speed=1
ball_angle=$1
ball_angle="${ball_angle:=310}"


calc_velocities() {
	ball_velocity_x=$(echo "scale=3; c($ball_angle*$pi/180)" | bc -l )
	ball_velocity_y=$(echo "scale=3; -s($ball_angle*$pi/180)" | bc -l )
}

move_ball() {
	ball_x=$(echo "scale=3; $ball_x + $ball_velocity_x * $ball_speed" | bc -l)
	ball_y=$(echo "scale=3; $ball_y + $ball_velocity_y * $ball_speed" | bc -l)
}

calc_ball_position() {
	old_ball_row="$ball_row"
	old_ball_column="$ball_column"
	ball_row=$(echo " scale=0; (($ball_y*0.5)+0.5)/1" | bc -l)
	ball_column=$(echo " scale=0; (($ball_x)+0.5)/1" | bc -l)
}

bounce_x() {
	ball_angle=$(( (540-ball_angle) % 360 ))
	calc_velocities
}

bounce_y() {
	ball_angle=$(( 360-ball_angle ))
	calc_velocities
}

draw_player_in_frame() {
	reset_line "$player_position_y"
	draw "████████████" "$player_position_y" "$player_position_x"
}

draw_ball_in_frame() {
	for (( i=0; i<4; i++ )) ; do
		draw "${ball[$i]}" "$((ball_row+i))" "$ball_column"
	done
}

erase_ball_in_frame() {
	for (( i=0; i<4; i++ )) ; do
		draw "        " "$((old_ball_row+i))" "$old_ball_column"
	done
}

draw() {
	local new_element="$1"
	local new_element_row="$2"
	local new_element_col="$3"

	local string_to_change=${frame[$new_element_row]}
	local new_string=${string_to_change:0:$((new_element_col-1))}$new_element${string_to_change:$((new_element_col-1+${#new_element}))}
	frame[new_element_row]="$new_string"

	changed_rows[new_element_row]=true
}

draw_frame() {
	for (( i=1 ; i<rows ; i++)) ; do
		if [[ ${changed_rows[i]} = "true" ]] ; then
			printf "\033[%s;1H%s" "$i" "${frame[$i]}"
			unset "changed_rows[i]"
		fi
	done
}

stop() {
	printf "\033[%s;1H" "$((rows+1))"

	printf "%s\n" "${timers[@]}" > arklogs/timer.txt

	local sum=0
	for time in "${timers[@]}" ; do
		((sum+=time))
	done
	average_time=$(echo "scale=3; $sum/$frames" | bc -l)
	echo -e "average loop time: ${average_time}ms"
	echo "$(date +'%d/%m/%Y %R') - $average_time" >> arklogs/average_times.txt

	printf "\033[?25h"
	exit
}

trap stop SIGINT

printf "\033[?25l"
clear

get_config
init_from_config

calc_velocities
calc_ball_position
draw_ball_in_frame
draw_player_in_frame
draw_frame

stty -echo

now=$(date +%s%3N)
last_game_update="$now"
last_display="$now"

while true ; do
	start_time=$(date +%s%3N)  # start time in milliseconds
	now=$(date +%s%3N)
	read -t0.001 -n1 -s -r input
	[ -n "${input}" ] && active_input="$input"

	if (( now-last_game_update >= 10)); then

		case "$active_input" in
			"q")
				if (( player_position_x > 1 ))
				then
					((player_position_x--))
					draw_player_in_frame
				fi
				;;
			"d")
				if (( player_position_x < cols-12 ))
				then
					((player_position_x++))
					draw_player_in_frame
				fi
				;;
		esac
		

		if (( ball_row >= player_position_y-4 || ball_row <= 1 ))
		then
			bounce_y
		fi
		if (( ball_column >= cols-7 || ball_column <= 2 ))
		then
			bounce_x
		fi

		move_ball
		calc_ball_position

		erase_ball_in_frame
		draw_ball_in_frame
		active_input=
		last_game_update="$now"
	fi
	
	if (( now-last_display >= frame_refresh_delay )); then
		draw_frame
		last_display="$now"
	fi


	#printf "%s\n" "${!changed_rows[@]}" > uqss2.txt # DEBUG: rows to rewrite
	#printf "%s\n" "${frame[@]}" > uqss.txt # DEBUG: the whole frame

    ((frames++))
	if [[ ${config[debug]} = true ]]; then
		printf "\033[1;1H%d" $frames
		printf "\033[2;1Hvx:%s" "$ball_velocity_x"
		printf "\033[3;1Hvy:%s" "$ball_velocity_y"
		printf "\033[4;1Hangle:%s" "$ball_angle"
		printf "\033[5;1Hrow:%s col:%s" "$ball_row" "$ball_column"
	fi

	end_time=$(date +%s%3N)  # # end time in milliseconds
	duration_ms=$((end_time - start_time))  # duration in milliseconds
	timers+=("$duration_ms")
done