# EDITOR ALIASES
alias jmacs="jmacs -nobackups"
alias ls="lsd"

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# SPACEFISH PROMPT CONFIG
set -g SPACEFISH_TIME_SHOW false
set -g SPACEFISH_USER_SHOW needed
set -g SPACEFISH_HOST_SHOW needed
set -g SPACEFISH_PROMPT_ADD_NEWLINE true
set -g SPACEFISH_PROMPT_SEPARATE_LINE true
# set -g SPACEFISH_BATTERY_SHOW false
set -g SPACEFISH_EXIT_CODE_SHOW true
set -x _JAVA_AWT_WM_NONREPARENTING 1

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

# eval (asdf exec direnv hook fish)
