#!/usr/bin/env fish

# find command description
# find PATHS TO SEARCH


set rofi_path (fd -e js -e md -e org -e py --search-path=/home/gigi/{Code/Current,Media/{documentos,org}} | rofi -dmenu -p "🗊")

if [ -n "$rofi_path" ]
    echo $rofi_path
    emacsclient -c $rofi_path
end
