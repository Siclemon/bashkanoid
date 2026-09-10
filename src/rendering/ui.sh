#!/bin/bash

initialize_game_area() {
    game_area_width=
    calc_game_area_width
    game_area_height=$(( screen_height - 4 ))
    game_area_first_col=$(( (screen_width - game_area_width) / 2 ))
    game_area_first_row=2
    game_area_last_col=$(( game_area_first_col + game_area_width ))
    game_area_last_row=$(( game_area_first_row + game_area_height ))
}

draw_game_area_frame() {
    draw_border_around $game_area_first_row $game_area_last_row $game_area_first_col $game_area_last_col
}

# draw_game_area_framee() {
#     local x y
#     local frame_min_y frame_max_y frame_min_x frame_max_x
#     frame_min_y=$((game_area_first_row-1))
#     frame_max_y=$((game_area_last_row+1))
#     frame_min_x=$((game_area_first_col-2))
#     frame_max_x=$((game_area_last_col+2))
#     for (( y=frame_min_y; y<=frame_max_y; y++ )); do
#         for (( x=frame_min_x; x<=frame_max_x; x++)); do
#             (( y == frame_min_y || y == frame_max_y || x <= frame_min_x + 1 || x >= frame_max_x - 1 )) && printf "\033[%s;%sH%s" "$y" "$x" "█"
#         done
#     done
# }

calc_game_area_width() {
    game_area_width=$(max $((screen_width*7/10)) 48)
    game_area_width=$(( (game_area_width / BRICK_WIDTH) * BRICK_WIDTH ))
}

max() {
    local value_1 value_2
    value_1=$1
    value_2=$2
    echo $(( value_1 > value_2 ? value_1 : value_2 ))
}