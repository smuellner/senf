_senf_complete() {
	local commands="doctor update reinstall plugins plugin path reload help"
	COMPREPLY=( $(compgen -W "$commands" -- "${COMP_WORDS[1]}") )
}
complete -F _senf_complete senf
