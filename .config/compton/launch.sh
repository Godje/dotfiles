#!/bin/bash

killall -q compton

# compton -vsync opengl

compton 

# compton -r 30 -o 0.8 --shadow-offset-x -20 --shadow-offset-y -20 -c -C -z -f --no-fading-openclose --no-fading-destroyed-argb --vsync opengl --blur-background --blur-background-fixed --blur-kern 9x9gaussian 
