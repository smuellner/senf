#!/bin/sh

#  ---------------------------------------------------------------------------
#
#  Description:  This file initalizes the senf env.
#
#  Sections:
#  1.   Core functions 
#  2.   Exports
#  3.   Aliases 
#  4.   General and often used functions
#  5.   Loaud user profile
#  6.   Load plugins
#  7.   Show error summary
# 
#  ---------------------------------------------------------------------------
SENF_PATH="${SENF_PATH:-${HOME}/.senf}"

#   -------------------------------
#   1.  CORE
#   -------------------------------
source "${SENF_PATH}/core/core.sh"


#   -------------------------------
#   2.  EXPORTS
#   -------------------------------
source "${SENF_PATH}/core/exports.sh"


#   -------------------------------
#   3.  ALIASES
#   -------------------------------
source "${SENF_PATH}/core/alias.sh"


#   -------------------------------
#   4.  GENERAL FUNCTIONS
#   -------------------------------
source "${SENF_PATH}/core/functions.sh"
source "${SENF_PATH}/core/commands.sh"
if [[ -n "${ZSH_VERSION:-}" ]]; then
	source "${SENF_PATH}/core/zsh.sh"
elif [[ -n "${BASH_VERSION:-}" ]]; then
	source "${SENF_PATH}/core/bash.sh"
fi


#   -------------------------------
#   5.  Source user profile
#   -------------------------------
if [[ "${SENF_SKIP_USER_PROFILE:-0}" != 1 ]] && test -e "${HOME}/.senf_profile"; then
	source "${HOME}/.senf_profile"
fi
senfNormalizePath

#   -------------------------------
#   6.  LOAD PLUGINS
#   -------------------------------
if [[ -z "${plugins+x}" ]]; then
	plugins=()
fi
if [[ -z "${senf_plugins+x}" ]]; then
	senf_plugins=()
fi
loadPlugins
loadUserPlugins
senfLoadPromptPlugins
senfInstallLazyHook

#   -------------------------------
#   7.  ERROR SUMMARY
#   -------------------------------
if [[ "${SENF_SHOW_SUMMARY:-0}" == 1 ]]; then
	senfErrorSummary
fi
