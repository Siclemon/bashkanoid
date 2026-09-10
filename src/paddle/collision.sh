#!/bin/bash

check_paddle_collision() {
    (( ball_row == paddle_row-BALL_HEIGHT && (ball_column>paddle_left-BALL_WIDTH && ball_column<paddle_left+PADDLE_WIDTH) ))
}