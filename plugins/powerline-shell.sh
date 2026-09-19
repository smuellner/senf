#!/bin/sh

case "${SENF_OS_NAME}:${SENF_ARCH_NAME}" in
  "${SENF_OS_LINUX}:amd64")
    powerline_cmd="powerline-go-linux-amd64"
    ;;
  "${SENF_OS_LINUX}:arm64")
    powerline_cmd="powerline-go-linux-arm64"
    ;;
  "${SENF_OS_MACOS}:amd64")
    powerline_cmd="powerline-go-darwin-amd64"
    ;;
  "${SENF_OS_MACOS}:arm64")
    powerline_cmd="powerline-go-darwin-arm64"
    ;;
  "${SENF_OS_WINDOWS}:amd64")
    powerline_cmd="powerline-go-windows-amd64.exe"
    ;;
  "${SENF_OS_WINDOWS}:arm64")
    powerline_cmd="powerline-go-windows-arm64.exe"
    ;;
  *)
    senfError "Unsupported Powerline platform: ${SENF_OS_NAME}/${SENF_ARCH_NAME}"
    return
    ;;
esac

powerline_shell="${SENF_PATH}/bin/${powerline_cmd}"

if test -f "${powerline_shell}"; then
	if [ -n "${ZSH_VERSION:-}" ]; then

		function powerline_precmd() {
			PS1="$(${powerline_shell} -error $? -shell zsh)"
		}

		function install_powerline_precmd() {
			for s in "${precmd_functions[@]}"; do
				if [ "$s" = "powerline_precmd" ]; then
					return
				fi
			done
			precmd_functions+=(powerline_precmd)
		}

		if [ "${TERM:-}" != "linux" ]; then
			install_powerline_precmd
		fi

		addSenf "powerline-shell (zsh)"

	elif [ -n "${BASH_VERSION:-}" ]; then

		function _update_ps1() {
			PS1="$(${powerline_shell} -error $?)"
		}

		if [ "${TERM:-}" != "linux" ] && [ -f "${powerline_shell}" ]; then
			PROMPT_COMMAND="_update_ps1${PROMPT_COMMAND:+; ${PROMPT_COMMAND}}"
		fi

		addSenf "powerline-shell (bash)"

	else
		senfError "Shell not supoorted ${SHELL}"
	fi
else
	senfInstallError "Missing powerline-shell install."
fi
