#!/bin/bash

caca() {
    ((var+=5))
}

pipi() {
    local var
    var=0
    caca
    echo $var
}

pipi