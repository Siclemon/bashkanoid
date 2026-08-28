#!/bin/bash

check_collisions() {
    if check_paddle_collision; then
        bounce_paddle
    elif is_ball_on_top || (is_ball_on_bottom && is_godmode) ; then
        bounce_y
    fi
    if is_ball_on_screen_side; then
        bounce_x
    fi
    if is_ball_in_bricks_rows; then
        handle_bricks_collision
    fi
}

is_ball_on_top() {
    (( ball_row <= 1 ))
}

is_ball_on_bottom() {
    (( ball_row >= paddle_row-BALL_HEIGHT ))
}

is_ball_on_screen_side() {
    (( ball_column >= screen_width-BALL_WIDTH-1 || ball_column <= 2 ))
}

is_ball_in_bricks_rows() {
    (( ball_row <= brick_rows + BRICK_HEIGHT + 1 ))
}