#!/bin/sh
#https://github.com/yshui/picom/blob/next/compton-default-fshader-win.glsl
picom --backend glx --glx-fshader-win "$(cat ~/Repositories/dot-files/greyscale_linux/compton-default-fshader-win.glsl)"
