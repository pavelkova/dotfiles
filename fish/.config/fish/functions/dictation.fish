function dictation
    switch $argv
        case start
            if test $CURRENT_RECORDING
                echo "Recording is already active"
            else
                set -Ux CURRENT_RECORDING (date +"%Y-%m-%d_%T")
                rec ~/Org/.audio/$CURRENT_RECORDING.wav &
                nerd-dictation begin &
                echo variable is: $CURRENT_RECORDING
            end
        case stop
            if test $CURRENT_RECORDING
                kill (pgrep -f $CURRENT_RECORDING)
                nerd-dictation end
                echo "Audio saved to ~/Org/.audio/$CURRENT_RECORDING.wav"
                set -e CURRENT_RECORDING
            else
                echo "No current recording"
            end

        case '*'
            echo "Invalid command"
    end
end
