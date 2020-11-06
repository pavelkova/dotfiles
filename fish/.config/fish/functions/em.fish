# Defined in - @ line 1
function em --description 'edit file in term with emacsclient'
	emacsclient -a '' -nw $argv;
end
