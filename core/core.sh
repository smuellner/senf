export SENF_PATH="${HOME}/.senf"
export SENF_CORE_PATH=${SENF_PATH}/core
export SENF_PLUGINS_PATH=${SENF_PATH}/plugins
export SENF_USER_PLUGINS_PATH=${HOME}/.senf_plugins

#   Log output functions
#   ------------------------------------------------------------
BOLD=$(tput bold)
NORMAL=$(tput sgr0)

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

	printf "$STARTCOLOR%b$ENDCOLOR" "$1" 1>&2
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

function addSenf() {
	if [[ -n $1 ]]; then
		SENF_ADDONS+=("$1")
	fi
}

function addSenfEnv() {
	if [[ -n $1 ]]; then
		SENF_ENV+=("$1")
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

function senf() {
	if [ ${#SENF_ADDONS[@]} -gt 0 ]; then
		printHead "ADDONS"
	fi
	for senfAddon in ${SENF_ADDONS[@]}; do
		printInfo "✅ ${senfAddon}"
	done
	if [ ${#SENF_ADDONS[@]} -gt 0 ]; then
		echo ""
	fi
	if [ ${#SENF_ENV[@]} -gt 0 ]; then
		printHead "ENV"
	fi
	for senfEnv in ${SENF_ENV[@]}; do
		printInfo "✅ ${senfEnv}"
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
		printInfo "❌ ${senfError}"
	done
	if [ ${#SENF_ERRORS[@]} -gt 0 ]; then
		echo ""
	fi

	if [ ${#SENF_INSTALL_ERRORS[@]} -gt 0 ]; then
		printHead "INSTALL ERRORS"
	fi
	for senfInstallError in ${SENF_INSTALL_ERRORS[@]}; do
		printInfo "❌ ${senfInstallError}"
	done
	if [ ${#SENF_INSTALL_ERRORS[@]} -gt 0 ]; then
		printInfo "👟 Run ${SENF_PATH}/install.sh"
		echo ""
	fi
}

#   Path functions
#   ------------------------------------------------------------
function setPath() {
	if [[ -d $1 ]]; then
		export PATH=$PATH:$1
	fi
}

function setLdLibraryPath() {
	if [ -d $1 ]; then
		export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$1
	fi
}

#   Plugins
#   ------------------------------------------------------------

function loadPlugins() {
	for plugin in ${plugins[@]}; do
		pluginPath="${SENF_PLUGINS_PATH}/${plugin}.sh"
		if [[ -f ${pluginPath} ]]; then
			source ${pluginPath}
		else
			senfError "Plugin '${plugin}' missing at '${pluginPath}'!"
		fi
	done
}

function loadUserPlugins() {
	for plugin in ${senf_plugins[@]}; do
		pluginPath="${SENF_USER_PLUGINS_PATH}/${plugin}.sh"
		if [[ -f ${pluginPath} ]]; then
			source ${pluginPath}
		else
			senfError "Plugin '${plugin}' missing at '${pluginPath}'!"
		fi
	done
}

#   Update
#   ------------------------------------------------------------
function senfUpdate() {
	cd ${SENF_PATH}
	git pull 
	cd -
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

_atom='/usr/local/bin/atom'
_code='/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code'
_see='/usr/local/bin/see'
_mate_installed='/usr/local/bin/mate'
_mate='/Applications/TextMate.app/Contents/Resources/mate'

function setDefaultEditorUI() {
    local possibleEditorUIs=(
		"${_code}"
		"${_atom}"
		"${_see}"
		"${_mate}"
		"${_mate_installed}"
	)
	getDefaultBinary "${possibleEditorUIs[@]}"
	if [[ ! -z ${defaultBinaryPath} ]]; then
		export EDITOR_UI="${defaultBinaryPath}"
		addSenfEnv "EDITOR_UI:\t${defaultBinaryPath}"
	fi
}

_gittower_installed='/usr/local/bin/gittower'
_gittower='/Applications/Tower.app/Contents/MacOS/gittower'
_stree='/Applications/SourceTree.app/Contents/Resources/stree'
function setDefaultGitUI() {
    local possibleGitUIs=(
		"${_gittower}"
		"${_gittower_installed}"
		"${_stree}"
	)
	getDefaultBinary "${possibleGitUIs[@]}"
	if [[ ! -z ${defaultBinaryPath} ]]; then
		export GIT_UI="${defaultBinaryPath}"
		addSenfEnv "GIT_UI:\t${defaultBinaryPath}"
	fi
}

#   set Defaults
#   ------------------------------------------------------------
setDefaultEditorUI
setDefaultGitUI
export EDITOR_CLI='/usr/bin/nano'
export GIT_CLI='/usr/bin/git'
