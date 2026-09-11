#!/bin/bash

IFS=''
echo -e "Press [ENTER] to start Configuration..."
for (( i=10; i>0; i--)); do
    
    printf "\rStarting in $i seconds..."
    read -s -N 1 -t 1 key
    
    if [ "$key" = $'\e' ]; then
        echo -e "\n [ESC] Pressed"
        break
        elif [ "$key" == $'\x0a' ] ;then
        echo -e "\n [Enter] Pressed"
        break
    fi
    
done
