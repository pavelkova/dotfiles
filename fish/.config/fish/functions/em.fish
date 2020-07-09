# Defined in /home/gigi/.config/fish/functions/em.fish @ line 2
function em --description 'emacs in console with minimal config'
	emacs -nw -q -bg none -l /home/gigi/.emacs.d/init-nw.el $argv;
end
