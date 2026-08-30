#!/bin/bash

is_alive() {
    local brick_line="$1"
    local brick_index="$2"
    local -n row="brick_row_$brick_line"

    (( row[brick_index]/10000 > 0 ))
}

get_health() {
    local brick_line="$1"
    local brick_index="$2"
    local -n row="brick_row_$brick_line"
    local brick_health

    brick_health=$(( row[brick_index] / 10000 ))

    echo "$brick_health"
}

get_column() {
    local brick_line="$1"
    local brick_index="$2"
    local -n row="brick_row_$brick_line"
    local brick_column

    brick_column=$(( row[brick_index] % 1000 ))

    echo "$brick_column"
}

damage_brick() {
    local brick_line="$1"
    local brick_index="$2"
    local damage="$3"
    local -n row="brick_row_$brick_line"

    row[brick_index]=$(( row[brick_index] - 10000 * damage ))
}