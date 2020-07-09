# EDITOR ALIASES
alias jmacs="jmacs -nobackups"
alias em="emacsclient -a '' -c"

# SPACEFISH PROMPT CONFIG
set -g SPACEFISH_TIME_SHOW true
set -g SPACEFISH_USER_SHOW always
set -g SPACEFISH_HOST_SHOW always

# VTERM
function vterm_printf;
    if [ -n "$TMUX" ]
        # tell tmux to pass the escape sequences through
        # (Source: http://permalink.gmane.org/gmane.comp.terminal-emulators.tmux.user/1324)
        printf "\ePtmux;\e\e]%s\007\e\\" "$argv"
    else if string match -q -- "screen*" "$TERM"
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf "\eP\e]%s\007\e\\" "$argv"
    else
        printf "\e]%s\e\\" "$argv"
    end
end

function fish_vterm_prompt_end;
    vterm_printf '51;A'(whoami)'@'(hostname)':'(pwd)
end
function track_directories --on-event fish_prompt; fish_vterm_prompt_end; end

# ASDF & DIRENV
# comment when using asdf-direnv
# source ~/.asdf/asdf.fish

# automatically start or connect to tmux session when entering project directory
function autotmux --on-variable TMUX_SESSION_NAME
        if test -n "$TMUX_SESSION_NAME" #only if set
    if test -z $TMUX #not if in TMUX
      if tmux has-session -t $TMUX_SESSION_NAME
        exec tmux new-session -t "$TMUX_SESSION_NAME"
      else
        exec tmux new-session -s "$TMUX_SESSION_NAME"
      end
    end
  end
end

set -U fish_user_paths ~/.asdf/bin $fish_user_path

eval (asdf exec direnv hook fish)
