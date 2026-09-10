#!/bin/bash

# is_alive() {
#     local brick_line="$1"
#     local brick_index="$2"
#     local -n row="brick_row_$brick_line"

#     (( row[brick_index]/10000 > 0 ))
# }

get_brick_data() {
    local brick_line="$1"
    local brick_index="$2"
    local -n row="brick_row_$brick_line"

    brick_health=$(( row[brick_index] / 10000 ))
    brick_column=$(( row[brick_index] % 1000 ))
    brick_type=$(( (row[brick_index] % 10000) / 1000 ))
}

damage_brick() {
    local brick_line="$1"
    local brick_index="$2"
    local damage="$3"
    local -n row="brick_row_$brick_line"

    row[brick_index]=$(( row[brick_index] - 10000 * damage ))
}