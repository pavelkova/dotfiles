function xmonad-layout -a KEY ICON
    xdotool key Super+l $KEY
    ln -sf ~/.xmonad/layout-indicators/$ICON.svg ~/.xmonad/current_layout.svg
end
