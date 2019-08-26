#!/usr/bin/env fish

# find command description
# find PATHS TO SEARCH

# set rofi_path (find "$HOME" -path ' \. ' -prune -o -not -name '. ' | rofi -dmenu -p "🗊")

set rofi_path (find Code/Current/ \
                    Media/org/ \
                    Media/documentos/ \
                      -not -path '*/.git*' \
                      -not -path '*/.projectile' \
                      -not -path '*/.asdf*' \
                      -not -path '*/node_modules*' \
                      -not -path '*/*[\.\_]*env*' \
                      -not -path '*/*env*' \
                      -not -path '*/*cache*' \
                      -not -path '*/*[\.\_]*cache*' \
                      -not -path '*/__pycache__*' \
                      -not -path '*/lib*' \
                      -not -path '*/var*' \
                      -not -path '*/deps/*' \
                      -not -path '*/migrations*' \
                      -not -path '*/_build*' \
                      -not -path '*/*build*' \
                      -not -path '*/*public*' \
                      -not -path '*/*backup*' \
                      -not -path '*/*.*BACKUP*' \
                    | rofi -dmenu -p "🗊")

if [ -n "$rofi_path" ]
    echo $rofi_path
    emacsclient -c $rofi_path
end
