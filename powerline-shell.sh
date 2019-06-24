#!/bin/bash
powerline_shell="/usr/local/bin/powerline-shell"

if [ ! -f ${powerline_shell} ]; then
	powerline_shell=$(find ~/Library/Python/*/bin -name powerline-shell -print | head -n 1)
fi

if test -f "${powerline_shell}"; then
	if [ -n "$ZSH_VERSION" ]; then

		function powerline_precmd() {
			PS1="$(${powerline_shell} --shell zsh $?)"
		}

		function install_powerline_precmd() {
			for s in "${precmd_functions[@]}"; do
				if [ "$s" = "powerline_precmd" ]; then
					return
				fi
			done
			precmd_functions+=(powerline_precmd)
		}

		if [ "$TERM" != "linux" ]; then
			install_powerline_precmd
		fi

		addSenf "powerline-shell (zsh)"

	elif [ -n "$BASH_VERSION" ]; then

		function _update_ps1() {
			PS1="$(${powerline_shell} $?)"
		}

		if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then
			PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
		fi
		
		addSenf "powerline-shell (bash)"

	else
		senfError "Shell not supoorted ${SHELL}"
	fi
else
	senfInstallError "Missing powerline-shell install."
fi
