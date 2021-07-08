# Defined in - @ line 1
function song --description 'find out what is playing in vlc or pyradio'
    playerctl metadata vlc:nowplaying
end
