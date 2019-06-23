if [ -f "/usr/local/bin/powerline-shell" ]; then
	if [ -n "$ZSH_VERSION" ]; then
		echo "✅ powerline-shell (zsh)"
		
		function powerline_precmd() {
			PS1="$(/usr/local/bin/powerline-shell --shell zsh $?)"
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
	elif [ -n "$BASH_VERSION" ]; then
		echo "✅ powerline-shell (bash)"
		
		function _update_ps1() {
			PS1=$(powerline-shell $?)
		}
		
		if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then
			PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
		fi
	else
		echo "❓ shell not supoorted ${SHELL}"
	fi
else
	echo "❓ Missing powerline-shell install."
	echo "👟 Run ~/.env/install.sh"
fi