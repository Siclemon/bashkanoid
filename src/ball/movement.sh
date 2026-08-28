#!/bin/bash

calc_velocities() {
    ball_velocity_x=$(echo "scale=3; c($ball_angle*$PI/180)" | bc -l )
    ball_velocity_y=$(echo "scale=3; -s($ball_angle*$PI/180)" | bc -l )
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

bounce_paddle() {
    local offset=$(( (ball_column + BALL_WIDTH / 2) - (paddle_left + PADDLE_WIDTH / 2) ))
    ball_angle=$(( 90 - offset * 7 ))
    calc_velocities
}
