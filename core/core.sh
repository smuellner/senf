#!/bin/sh

export SENF_PATH="${SENF_PATH:-${HOME}/.senf}"
export SENF_CORE_PATH="${SENF_CORE_PATH:-${SENF_PATH}/core}"
export SENF_PLUGINS_PATH="${SENF_PLUGINS_PATH:-${SENF_PATH}/plugins}"
export SENF_USER_PLUGINS_PATH="${SENF_USER_PLUGINS_PATH:-${HOME}/.senf_plugins}"

#   Detect OS
#   ------------------------------------------------------------
export SENF_OS_LINUX="linux"
export SENF_OS_MACOS="macos"
export SENF_OS_WINDOWS="windows"
case $(uname | tr '[:upper:]' '[:lower:]') in
  linux*)
    export SENF_OS_NAME=${SENF_OS_LINUX}
    ;;
  darwin*)
    export SENF_OS_NAME=${SENF_OS_MACOS}
    ;;
  msys*)
    export SENF_OS_NAME=${SENF_OS_WINDOWS}
    ;;
  *)
    export SENF_OS_NAME=notset
    ;;
esac

#   Detect CPU architecture for platform-specific tools
#   ------------------------------------------------------------
case $(uname -m) in
  arm64|aarch64)
    export SENF_ARCH_NAME="arm64"
    ;;
  x86_64|amd64)
    export SENF_ARCH_NAME="amd64"
    ;;
  *)
    export SENF_ARCH_NAME="$(uname -m | tr '[:upper:]' '[:lower:]')"
    ;;
esac

#   Log output functions
#   ------------------------------------------------------------
if [[ -t 2 ]] && command -v tput >/dev/null 2>&1; then
	BOLD="$(tput bold 2>/dev/null || true)"
	NORMAL="$(tput sgr0 2>/dev/null || true)"
else
	BOLD=""
	NORMAL=""
fi

function printWithStyle() {
	if [[ "$2" == "info" ]]; then
		COLOR="96m"
	elif [[ "$2" == "question" ]]; then
		COLOR="86m"
	elif [[ "$2" == "success" ]]; then
		COLOR="92m"
	elif [[ "$2" == "warning" ]]; then
		COLOR="93m"
	elif [[ "$2" == "danger" ]]; then
		COLOR="91m"
	elif [[ "$2" == "head" ]]; then
		COLOR="94m"
	elif [[ "$2" == "cmd" ]]; then
		COLOR="33m"
	else #default color
		COLOR="0m"
	fi

	STARTCOLOR="\e[$COLOR"
	ENDCOLOR="\e[0m"

	printf '%b%b%b' "$STARTCOLOR" "$1" "$ENDCOLOR" 1>&2
}

function printHead() {
	printWithStyle "${BOLD}== $1 ==${NORMAL}\n" "head"
}

function printQuestion() {
	printWithStyle "==> $1\n" "question"
}

function printInfo() {
	printWithStyle "==> $1\n" "info"
}

function printWarning() {
	printWithStyle "==> $1\n" "warning"
}

function printCmd() {
	printWithStyle "> $1\n" "cmd"
}

function printError() {
	printWithStyle "==> $1\n" "danger"
}

function errorExit() {
	printError $1
	exit 1
}

#   Senf functions
#   ------------------------------------------------------------
export SENF_ADDONS=()
export SENF_ENV=()
export SENF_ERRORS=()
export SENF_INSTALL_ERRORS=()
export SENF_LOADED_PLUGINS=()
export SENF_PENDING_PLUGINS=()
export SENF_FAILED_PLUGINS=()
export SENF_PLUGIN_API_VERSION=1
export SENF_LAZY_INITIALIZED=0

function addSenf() {
	if [[ -n $1 ]]; then
		for addon in "${SENF_ADDONS[@]}"; do
			[[ "$addon" == "$1" ]] && return 0
		done
		SENF_ADDONS+=("$1")
	fi
}

function addSenfEnv() {
	if [[ -n $1 ]]; then
		for env_item in "${SENF_ENV[@]}"; do
			[[ "$env_item" == "$1|\t$2" ]] && return 0
		done
		SENF_ENV+=("$1|\t$2")
	fi
}

function senfError() {
	if [[ -n $1 ]]; then
		SENF_ERRORS+=("$1")
	fi
}

function senfInstallError() {
	if [[ -n $1 ]]; then
		SENF_INSTALL_ERRORS+=("$1")
	fi
}

function senfSummary() {
	if [ ${#SENF_ADDONS[@]} -gt 0 ]; then
		printHead "ADDONS"
	fi
	for senfAddon in ${SENF_ADDONS[@]}; do
		printf "%2s  %-s\n" "✔️" "${senfAddon}"
	done
	if [ ${#SENF_ADDONS[@]} -gt 0 ]; then
		echo ""
	fi
	if [ ${#SENF_ENV[@]} -gt 0 ]; then
		printHead "ENV"
	fi
	for senfEnv in ${SENF_ENV[@]}; do
		echo "${senfEnv}"|awk -F'|' '{printf "%2s  %-10s\t%-s\n", "✔️", $1, $2}'
	done
	if [ ${#SENF_ENV[@]} -gt 0 ]; then
		echo ""
	fi

	senfErrorSummary
}

function senfErrorSummary() {
	if [ ${#SENF_ERRORS[@]} -gt 0 ]; then
		printHead "ERRORS"
	fi
	for senfError in ${SENF_ERRORS[@]}; do
		printError "❌ ${senfError}"
	done
	if [ ${#SENF_ERRORS[@]} -gt 0 ]; then
		echo ""
	fi

	if [ ${#SENF_INSTALL_ERRORS[@]} -gt 0 ]; then
		printHead "INSTALL ERRORS"
	fi
	for senfInstallError in ${SENF_INSTALL_ERRORS[@]}; do
		printError "❌ ${senfInstallError}"
	done
	if [ ${#SENF_INSTALL_ERRORS[@]} -gt 0 ]; then
		printInfo "👟 Run ${SENF_PATH}/install.sh"
		echo ""
	fi
}

#   Path functions
#   ------------------------------------------------------------
function setPath() {
	if [[ -d "$1" ]] && [[ ":${PATH}:" != *":${1}:"* ]]; then
		export PATH="${PATH:+${PATH}:}$1"
	fi
}

function setLdLibraryPath() {
	if [[ -d "$1" ]] && [[ ":${LD_LIBRARY_PATH}:" != *":${1}:"* ]]; then
		export LD_LIBRARY_PATH="${LD_LIBRARY_PATH:+${LD_LIBRARY_PATH}:}$1"
	fi
}

#   Plugins
#   ------------------------------------------------------------

function loadPlugins() {
	for plugin in "${plugins[@]}"; do
		senfRegisterPlugin "$plugin"
	done
}

function loadUserPlugins() {
	for plugin in "${senf_plugins[@]}"; do
		senfRegisterPlugin "$plugin" "${SENF_USER_PLUGINS_PATH}"
	done
}

function senfRegisterPlugin() {
	local plugin="$1"
	local plugin_root="${2:-${SENF_PLUGINS_PATH}}"
	local plugin_path="${plugin_root}/${plugin}.sh"
	[[ -z "$plugin" ]] && return 0
	if [[ ! -f "$plugin_path" && "$plugin_root" == "${SENF_PLUGINS_PATH}" ]]; then
		plugin_path="${SENF_USER_PLUGINS_PATH}/${plugin}.sh"
	fi
	if [[ ! -f "$plugin_path" ]]; then
		senfError "Plugin '${plugin}' missing at '${plugin_path}'!"
		return 1
	fi
	for loaded in "${SENF_PENDING_PLUGINS[@]}" "${SENF_LOADED_PLUGINS[@]}"; do
		[[ "$loaded" == "$plugin" ]] && return 0
	done
	SENF_PENDING_PLUGINS+=("$plugin")
}

# Stable plugin API aliases for third-party plugins.
function senf_plugin_register() { senfRegisterPlugin "$@"; }
function senf_plugin_load() { senfLoadPlugin "$@"; }

function senfLoadPlugin() {
	local plugin="$1"
	local plugin_root="${2:-${SENF_PLUGINS_PATH}}"
	local plugin_path="${plugin_root}/${plugin}.sh"
	local pending
	local load_status
	[[ -z "$plugin" ]] && return 0
	for loaded in "${SENF_LOADED_PLUGINS[@]}"; do
		[[ "$loaded" == "$plugin" ]] && return 0
	done
	for failed in "${SENF_FAILED_PLUGINS[@]}"; do
		[[ "$failed" == "$plugin" ]] && return 1
	done
	if [[ ! -f "$plugin_path" && "$plugin_root" == "${SENF_PLUGINS_PATH}" ]]; then
		plugin_path="${SENF_USER_PLUGINS_PATH}/${plugin}.sh"
	fi
	if [[ ! -f "$plugin_path" ]]; then
		senfError "Plugin '${plugin}' missing at '${plugin_path}'!"
		return 1
	fi
	for pending in "${SENF_PENDING_PLUGINS[@]}"; do
		if [[ "$pending" == "$plugin" ]]; then
			SENF_PLUGIN_NAME="$plugin"
			SENF_PLUGIN_DIR="$(dirname "$plugin_path")"
			source "$plugin_path"
			load_status=$?
			if (( load_status != 0 )); then
				SENF_FAILED_PLUGINS+=("$plugin")
				return "$load_status"
			fi
			SENF_LOADED_PLUGINS+=("$plugin")
			return 0
		fi
	done
	return 0
}

function senfLoadAllPlugins() {
	local plugin
	local load_result=0
	for plugin in "${SENF_PENDING_PLUGINS[@]}"; do
		senfLoadPlugin "$plugin" || load_result=1
	done
	SENF_LAZY_INITIALIZED=1
	return "$load_result"
}

function senfLazyInit() {
	[[ "${SENF_LAZY_INITIALIZED:-0}" == 1 ]] && return 0
	senfLoadAllPlugins
	senfRefreshPrompt
}

function senfRefreshPrompt() {
	if type powerline_precmd >/dev/null 2>&1; then
		powerline_precmd
	elif type _update_ps1 >/dev/null 2>&1; then
		_update_ps1
	fi
}

function senfLoadPromptPlugins() {
	# Prompt providers must be ready before the first prompt is rendered.
	# Other plugins remain lazy and load from senfLazyInit.
	if [[ -n "${ZSH_VERSION:-}" ]]; then
		senfLoadPlugin oh-my-zsh 2>/dev/null || true
	fi
	senfLoadPlugin powerline-shell 2>/dev/null || true
	senfRefreshPrompt
}

function senfInstallLazyHook() {
	if [[ -n "${ZSH_VERSION:-}" ]]; then
		autoload -Uz add-zsh-hook 2>/dev/null
		add-zsh-hook precmd senfLazyInit
	elif [[ -n "${BASH_VERSION:-}" ]]; then
		case ";${PROMPT_COMMAND:-};" in
			*";senfLazyInit;"*) ;;
			*) PROMPT_COMMAND="senfLazyInit${PROMPT_COMMAND:+;${PROMPT_COMMAND}}" ;;
		esac
	fi
}

#   Update
#   ------------------------------------------------------------

function senfUpdate() {
	(
		cd "${SENF_PATH}" || return
		command git pull --ff-only && command ./install.sh
	)
}

function senfReinstall() {
	local current_dir="$(pwd)"
	local senf_repo
	local backup_path="${SENF_PATH}.backup.$(date +%Y%m%d%H%M%S)"
	senf_repo="$(cd "${SENF_PATH}" 2>/dev/null && command git remote get-url origin)"
	if [[ -n "$senf_repo" ]]; then
		printHead "Reinstall senf"
		printInfo "${senf_repo}"
		if mv "${SENF_PATH}" "${backup_path}" && command git clone "$senf_repo" "${SENF_PATH}"; then
			"${SENF_PATH}/install.sh"
			printInfo "Previous installation preserved at ${backup_path}"
		else
			printError "Reinstall failed; restoring previous installation"
			[[ -d "${SENF_PATH}" ]] && mv "${SENF_PATH}" "${SENF_PATH}.failed.$(date +%s)"
			mv "$backup_path" "${SENF_PATH}"
			return 1
		fi
	fi
	cd "$current_dir" || return
}

#   Help
#   ------------------------------------------------------------
function senfHelp() {
	if [[ -t 1 ]] && command -v less >/dev/null 2>&1; then
		less "${SENF_PATH}/HELP.md"
	else
		command cat "${SENF_PATH}/HELP.md"
	fi
}

#   Http operations
#   ------------------------------------------------------------
function getHttpCode() {
	local http_url="$1"
	http_code=$(curl --write-out '%{http_code}' --silent \
		--connect-timeout 0.3 --max-time 1 --output /dev/null "$http_url")
}

#   Default application functions
#   ------------------------------------------------------------
function getDefaultBinary() {
	for defaultBinaryPath in $@; do
		if [[ -x ${defaultBinaryPath} ]]; then
			return 0
		fi
	done
}

_atom_installed='/usr/local/bin/atom'
_atom='/Applications/Atom.app/Contents/MacOS/atom'
_see='/usr/local/bin/see'
_code_installed='/usr/local/bin/code'
_code='/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code'
_see='/usr/local/bin/see'
_mate_installed='/usr/local/bin/mate'
_mate='/Applications/TextMate.app/Contents/Resources/mate'
_brackets_installed='/usr/local/bin/brackets'
_brackets='/Applications/Brackets.app/Contents/Resources/brackets.sh'
function setDefaultEditorUI() {
	[[ "${SENF_EDITOR_DETECTED:-0}" == 1 ]] && return 0
	local possibleEditorUIs=(
		"${_code_installed}"
		"${_code}"
		"${_atom_installed}"
		"${_atom}"
		"${_see}"
		"${_mate_installed}"
		"${_mate}"
		"${_brackets_installed}"
		"${_brackets}"
	)
	getDefaultBinary "${possibleEditorUIs[@]}"
	if [[ ! -z ${defaultBinaryPath} ]]; then
		export EDITOR_UI="${defaultBinaryPath}"
		addSenfEnv "EDITOR_UI" "${defaultBinaryPath}"
	fi
	SENF_EDITOR_DETECTED=1
}

_gittower_installed='/usr/local/bin/gittower'
_gittower='/Applications/Tower.app/Contents/MacOS/gittower'
_stree='/Applications/SourceTree.app/Contents/Resources/stree'
function setDefaultGitUI() {
	[[ "${SENF_GIT_UI_DETECTED:-0}" == 1 ]] && return 0
	local possibleGitUIs=(
		"${_gittower}"
		"${_gittower_installed}"
		"${_stree}"
	)
	getDefaultBinary "${possibleGitUIs[@]}"
	if [[ ! -z ${defaultBinaryPath} ]]; then
		export GIT_UI="${defaultBinaryPath}"
		addSenfEnv "GIT_UI" "${defaultBinaryPath}"
	fi
	SENF_GIT_UI_DETECTED=1
}

#   set Defaults
#   ------------------------------------------------------------
setDefaultEditorUI
setDefaultGitUI
export EDITOR_CLI='/usr/bin/nano'
export GIT_CLI='/usr/bin/git'
