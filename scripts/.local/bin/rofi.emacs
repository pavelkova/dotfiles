#!/usr/bin/env fish

# find command description
# find PATHS TO SEARCH


set rofi_path (fd -e conf -e el -e epub -e js -e lua -e md -e org -e py -e pdf -e rb -e rc --search-path=/home/gigi/{.config,.local/bin,Code/Current,Media/{biblioteca,documentos,org},Sync/.dotfiles/*/.*} | rofi -dmenu -p "🗊")

if [ -n "$rofi_path" ]
    echo $rofi_path
    emacsclient -c $rofi_path
end
