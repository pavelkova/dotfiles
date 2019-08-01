#!/usr/bin/env fish

set rofi_path (find "$HOME" -path ' \. ' -prune -o -not -name '. ' | rofi -dmenu -p "🗊")

if [ -n "$rofi_path" ]
    echo $rofi_path
    emacsclient -c $rofi_path
end
