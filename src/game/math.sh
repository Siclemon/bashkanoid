#!/bin/bash

max() {
    local value_1 value_2
    value_1=$1
    value_2=$2
    echo $(( value_1 > value_2 ? value_1 : value_2 ))
}